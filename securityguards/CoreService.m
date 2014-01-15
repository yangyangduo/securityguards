//
//  CoreService.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CoreService.h"
#import "NetworkModeChangedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "DeviceCommandEvent.h"
#import "XXEventNameFilter.h"
#import "Shared.h"
#import "UnitManager.h"

/*  Command Handler  */
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandGetAccountHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandUpdateUnitNameHandler.h"
#import "AlertView.h"

#define NETWORK_CHECK_INTERVAL 5
#define UNIT_REFRESH_INTERVAL  10
#define HEART_BEAT_TIMEOUT     1.f

@implementation CoreService {
    Reachability* reachability;
    NSTimer *tcpConnectChecker;
    NSTimer *unitRefresTimer;
    NSArray *mayUsingInternalNetworkCommands;
    
    NetworkMode networkMode;
    
    dispatch_queue_t serialQueue;
    
    /*
     * no            0
     * wifi net      1
     * wifi no net   2
     * 3g            3
     */
    NSUInteger flag;
}

@synthesize tcpService;
@synthesize restfulService;

@synthesize state = _state_;
@synthesize needRefreshUnit = _needRefreshUnit_;

#pragma mark -
#pragma mark Initializations

/*    Singleton    */
+ (CoreService *)defaultService {
    static CoreService *service = nil;
    static dispatch_once_t serviceOnceToken;
    dispatch_once(&serviceOnceToken, ^{
        service = [[CoreService alloc] init];
    });
    return service;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    /* default property set */
    
    _state_ = ServiceStateClosed;
    networkMode = NetworkModeNotChecked;
    _needRefreshUnit_ = YES;
    
    mayUsingInternalNetworkCommands = [NSArray arrayWithObjects:COMMAND_KEY_CONTROL, COMMAND_GET_CAMERA_SERVER, nil];
    
    serialQueue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    
    /* Network monitor */
    reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self startMonitorNetworks];
}

#pragma mark -
#pragma mark Execute device command

/*
 *
 * Execute device command
 *.
 * NO Network Environment  ---> RETURN
 * 3G                      ---> TCP CONNECTION
 * WIFI  WITH UNIT         ---> RESTFUL SERVICE
 * WIFI  WITH NO UNIT      ---> TCP CONNECTION
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    if(_state_ != ServiceStateOpenned) {
#ifdef DEBUG
        NSLog(@"[Core Service] Service is not ready, [%@] can't be executed.", command.commandName);
#endif
        return;
    }
    // Execute command will never be executed in main thread
    if([NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self executeDeviceCommandInternal:command];
        });
    } else {
        [self executeDeviceCommandInternal:command];
    }
}

- (void)executeDeviceCommandInternal:(DeviceCommand *)command {
    /* Find the best command executor */
    id<CommandExecutor> executor = [self determineCommandExcutor:command];
    if(executor != nil) {
//#ifdef DEBUG
//        NSLog(@"[Core Service] Execute [%@] From [%@]", command.commandName, [executor executorName]);
//#endif
        [executor executeCommand:command];
    } else {
#ifdef DEBUG
        NSLog(@"[Core Service] Executor not found, [%@] can't be executed.", command.commandName);
#endif
    }
}

- (void)queueCommand:(DeviceCommand *)command {
#ifdef DEBUG
    NSLog(@"[Core Service] Queue command [%@].", command.commandName);
#endif
    [self.tcpService queueCommand:command];
}

- (id<CommandExecutor>)determineCommandExcutor:(DeviceCommand *)command {
    /*
     * If the device command has explicit specify the network mode
     * that of course we know which executor should to be used
     */
    if(command.commmandNetworkMode == CommandNetworkModeInternal) {
        return self.restfulService;
    } else if(command.commmandNetworkMode == CommandNetworkModeExternal) {
        return self.tcpService;
    }
    
    /*
     * At first , check the command wether has been defined in 
     * Internal network commands list
     */
    if([self commandCanDeliveryInInternalNetwork:command]) {
        if([self currentNetworkMode] == NetworkModeInternal) {
            return self.restfulService;
        }
    }
    
    if(self.tcpService.isConnectted) {
        return self.tcpService;
    }
    
    return nil;
}

- (BOOL)commandCanDeliveryInInternalNetwork:(DeviceCommand *)command {
    if(mayUsingInternalNetworkCommands == nil) return NO;
    /* 
     * This is a special command
     * Get all units only execute from tcp (both master device code and unit server url is blank)
     * Get one unit can execute in rest or tcp
     */
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        if([XXStringUtils isBlank:command.masterDeviceCode]) {
            DeviceCommandGetUnit *cmd = (DeviceCommandGetUnit *)command;
            return ![XXStringUtils isBlank:cmd.unitServerUrl];
        } else {
            return YES;
        }
    }
    
    for(int i=0; i<mayUsingInternalNetworkCommands.count; i++) {
        NSString *cmdName = [mayUsingInternalNetworkCommands objectAtIndex:i];
        if([cmdName isEqualToString:command.commandName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark Handle device command

- (void)handleDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    
//#ifdef DEBUG
//    NSString *networkModeString = [XXStringUtils emptyString];
//    if(command.commmandNetworkMode == CommandNetworkModeExternal) {
//        networkModeString = @"External";
//    } else if(command.commmandNetworkMode == CommandNetworkModeInternal) {
//        networkModeString = @"Internal";
//    }
//    NSLog(@"[Core Service] Received [%@] From [%@]", command.commandName, networkModeString);
//#endif

    // Security key is invalid or expired
    if(command.resultID == -3000 || command.resultID == -2000 || command.resultID == -1000) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Shared shared].app logout];
            return;
        });
    }
    
    // If the resutID of command is equal -100
    // that the command should be ignore,
    // our client will never process this command.
    if(command.resultID == -100) return;
    
    // If the service is not served
    if(_state_ != ServiceStateOpenned) {
#ifdef DEBUG
        NSLog(@"[Core Service] Service is't opened, can't handle [%@].", command.commandName);
#endif
        return;
    }
    
    DeviceCommandHandler *handler = nil;
    
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetUnitsHandler alloc] init];
    } else if([COMMAND_GET_ACCOUNT isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetAccountHandler alloc] init];
    } else if([COMMAND_PUSH_NOTIFICATIONS isEqualToString:command.commandName] || [COMMAND_GET_NOTIFICATIONS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetNotificationsHandler alloc] init];
    } else if([COMMAND_PUSH_DEVICE_STATUS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateDevicesHandler alloc] init];
    } else if([COMMAND_CHANGE_UNIT_NAME isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateUnitNameHandler alloc] init];
    }
        
    if(handler != nil) {
        [handler handle:command];
    }
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *commandReceivedEvent = (DeviceCommandEvent *)event;
        [self handleDeviceCommand:commandReceivedEvent.command];
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"deviceCommandDeliveryServiceSubscriber";
}

#pragma mark -
#pragma mark Open or stop delivery service

- (void)startService {
    if(_state_ != ServiceStateOpenned && _state_ != ServiceStateOpenning) {
#ifdef DEBUG
        NSLog(@"[Core Service] Service starting.");
#endif
        _state_ = ServiceStateOpenning;
        
        // Load all units from disk
        [[UnitManager defaultManager] loadUnitsFromDisk];
    
        XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventName:EventDeviceCommand]];
        [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];

        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
        }

        // Start a network checker
        // Every 5 seconds to check the tcp is connectted ?
        // If it was closed, then should open it again.
        tcpConnectChecker = [NSTimer scheduledTimerWithTimeInterval:NETWORK_CHECK_INTERVAL target:self selector:@selector(checkTcp) userInfo:nil repeats:YES];
        [tcpConnectChecker fire];
        
        _state_ = ServiceStateOpenned;
        
#ifdef DEBUG
        NSLog(@"[Core Service] Service started.");
#endif
    }
}

- (void)stopService {
    if(_state_ != ServiceStateClosed && _state_ != ServiceStateClosing) {
        _state_ = ServiceStateClosing;
        
        [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
        
        [self stopRefreshCurrentUnit];
        
        // Stop TCP Connection checker
        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
            tcpConnectChecker = nil;
        }
        
        // Disconnect tcp connection
        [self.tcpService disconnect];
        
        // Synchronize memory units to disk
        [[UnitManager defaultManager] syncUnitsToDisk];
        
#ifdef DEBUG
        NSLog(@"[Core Service] Service stopped.");
#endif
        _state_ = ServiceStateClosed;
    }
}

#pragma mark -
#pragma mark TCP Connection checker

- (void)checkTcp {
    [self startTcpIfNeed];
}

- (void)startTcpIfNeed {
    if(!self.tcpService.isConnecttingOrConnectted) {
        [self.tcpService connect];
    }
}

- (void)notifyTcpConnectionOpened {
    [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
    [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetNotifications]];
    [self notifyNetworkModeUpdate:NetworkModeExternal];
}

- (void)notifyTcpConnectionClosed {
    [self notifyNetworkModeUpdate:NetworkModeNotChecked];
}

#pragma mark -
#pragma mark Refresh current unit

- (void)startRefreshCurrentUnit {
    [self stopRefreshCurrentUnit];
    unitRefresTimer = [NSTimer scheduledTimerWithTimeInterval:UNIT_REFRESH_INTERVAL target:self selector:@selector(refreshUnit) userInfo:nil repeats:YES];
    [unitRefresTimer fire];
}

- (void)stopRefreshCurrentUnit {
    if(unitRefresTimer != nil) {
        [unitRefresTimer invalidate];
        unitRefresTimer = nil;
    }
}

- (void)refreshUnit {
    dispatch_async(serialQueue, ^{
        Unit *unit = [UnitManager defaultManager].currentUnit;
        if(unit != nil) {
            // This is a sync method, not checkInternalOrNotInternalNetwork (async method)
            // Here you must check net work sync, then continue execute command
            [self checkIsReachableInternalUnit];
            
            if(self.needRefreshUnit) {
                // Update current unit
                DeviceCommand *command = [CommandFactory commandForType:CommandTypeGetUnits];
                command.masterDeviceCode = unit.identifier;
                command.hashCode = unit.hashCode;
                [self executeDeviceCommand:command];
            }
            
            // Send heart beat command
            [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeSendHeartBeat]];
        }
    });
}

- (void)fireRefreshUnit {
    if(unitRefresTimer != nil) {
        [unitRefresTimer fire];
    }
}

#pragma mark -
#pragma mark Network monitor

- (void)startMonitorNetworks {
	// Here we set up a NSNotification observer. The Reachability that caused the notification
	// is passed in the object parameter
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = notification.object;
    if(reach == nil) return;
    if(reach.isReachable) {
        if(reach.isReachableViaWiFi) {
            // WIFI &&   Network
            flag = 1;
        } else if(reach.isReachableViaWWAN) {
            // 3G   &&   Network
            flag = 3;
        } else {
            // Else, ignore
        }
    } else {
        if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable) {
            // WIFI && No Network
            flag = 2;
        } else {
            // No (WIFI && 3G && 2G && Network)
            flag = 0;
        }
    }
    
    if(flag == 1 || flag == 2) {
        [self checkInternalOrNotInternalNetwork];
    } else {
        if(flag == 0) {
            [self setCurrentNetworkMode:NetworkModeNotChecked];
        } else {
            if([self currentNetworkMode] != NetworkModeExternal) {
                [self setCurrentNetworkMode:NetworkModeExternal];
            }
        }
    }
}

- (void)checkInternalOrNotInternalNetwork {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkIsReachableInternalUnit];
    });
}

- (void)checkIsReachableInternalUnit {
    @synchronized(self) {
        if([UnitManager defaultManager].currentUnit == nil
           || [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable) {
            networkMode = self.tcpService.isConnectted ? NetworkModeExternal : NetworkModeNotChecked;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyNetworkModeUpdate:networkMode];
            });
            return;
        }
        
        NSString *url = [NSString stringWithFormat:@"http://%@:%d/heartbeat", [UnitManager defaultManager].currentUnit.localIP, [UnitManager defaultManager].currentUnit.localPort];
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:HEART_BEAT_TIMEOUT];
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(error == nil) {
            if(response) {
                NSHTTPURLResponse *rp = (NSHTTPURLResponse *)response;
                if(rp.statusCode == 200 && data != nil) {
                    NSString *unitIdentifier = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if([UnitManager defaultManager].currentUnit != nil) {
                        if([[UnitManager defaultManager].currentUnit.identifier isEqualToString:unitIdentifier]) {
                            networkMode = NetworkModeInternal;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self notifyNetworkModeUpdate:networkMode];
                            });
                            return;
                        }
                    }
                }
            }
        }
        
        networkMode = self.tcpService.isConnectted ? NetworkModeExternal : NetworkModeNotChecked;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyNetworkModeUpdate:networkMode];
        });
    }
}

- (void)setCurrentNetworkMode:(NetworkMode)mode {
    @synchronized(self) {
        if(networkMode != mode) {
            networkMode = mode;
            [self notifyNetworkModeUpdate:mode];
        }
    }
}

- (NetworkMode)currentNetworkMode {
    return networkMode;
}

- (void)notifyNetworkModeUpdate:(NetworkMode)mode {
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[NetworkModeChangedEvent alloc] initWithNetworkMode:mode]];
}

#pragma mark -
#pragma mark Getter and Setters

- (TCPCommandService *)tcpService {
    static dispatch_once_t tcpOnceToken;
    dispatch_once(&tcpOnceToken, ^{
        tcpService = [[TCPCommandService alloc] init];
    });
    return tcpService;
}

- (RestfulCommandService *)restfulService {
    static dispatch_once_t restOnceToken;
    dispatch_once(&restOnceToken, ^{
        restfulService = [[RestfulCommandService alloc] init];
    });
    return restfulService;
}

@end