//
//  CoreService.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Shared.h"
#import "CoreService.h"
#import "UnitManager.h"
#import "NetworkModeChangedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "DeviceCommandEvent.h"
#import "CurrentUnitChangedEvent.h"
#import "XXEventNameFilter.h"
#import "ScoringTools.h"

/*  Command Handler  */
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandGetAccountHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandUpdateUnitNameHandler.h"
#import "DeviceCommandGetSensorsHandler.h"
#import "DeviceCommandGetScoreHandler.h"

#import "XXAlertView.h"
#import "AQIManager.h"

#define NETWORK_CHECK_INTERVAL     5
#define UNIT_REFRESH_INTERVAL      10
#define HEART_BEAT_TIMEOUT         2.f
#define GETUNITS_MINITES_INTERVAL  60


// 执行网络状态检查任务的有序 队列
// 此Queue必须按顺序执行
static dispatch_queue_t networkModeCheckTaskQueue() {
    static dispatch_queue_t serialQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.hentre.familyguards.coreservice.network", DISPATCH_QUEUE_SERIAL);
    });
    return serialQueue;
}

@implementation CoreService {
    NSTimer *tcpSocketConnectionCheckTimer;
    NSTimer *refreshTaskTimer;
    
    /* 定义了哪些命令是可以在内网执行的 */
    NSArray *mayUsingInternalNetModeCommands;
    
    /* 
     * 定义了必须使用 Restful Executor 的命令
     * 内网只能用 rest 通讯
     * 外网则有 socket 和 rest 两种通讯方式
     */
    NSArray *usingRestfulForAnyNetModeCommands;
    
    /*
     * no            0
     * wifi net      1
     * wifi no net   2
     * 3g            3
     */
    NSUInteger flag;
    Reachability *reachability;
    
    NSObject *netModeLockObject;
}

@synthesize tcpService;
@synthesize restfulService;

@synthesize state = _state_;
@synthesize netMode = _netMode_;
@synthesize needRefreshUnit = _needRefreshUnit_;


// 获取后台服务线程 (单例)
- (NSThread *)coreServiceThread {
    static NSThread *_coreServiceThread_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreServiceThread_ = [[NSThread alloc] initWithTarget:self selector:@selector(coreServiceThreadEntryPoint) object:nil];
        [_coreServiceThread_ start];
    });
    return _coreServiceThread_;
}

- (void)coreServiceThreadEntryPoint {
    [[NSThread currentThread] setName:@"CoreServiceThread"];

    // tcp 通讯检查定时器, 每5秒检查一次连接状态 如果断开了 就再打开
    tcpSocketConnectionCheckTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:NETWORK_CHECK_INTERVAL target:self selector:@selector(checkTcp) userInfo:nil repeats:YES];
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)tcpSocketConnectionCheckTimer, kCFRunLoopDefaultMode);
    
    // 执行定时任务的定时器
    refreshTaskTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:UNIT_REFRESH_INTERVAL target:self selector:@selector(doTimerTask) userInfo:nil repeats:YES];
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)refreshTaskTimer, kCFRunLoopDefaultMode);
    
    // 开启 Runloop
    CFRunLoopRun();
    
#ifdef DEBUG
    NSLog(@"Core Service RunLoop Stopped. [You will never see this message]");
#endif
}

#pragma mark -
#pragma mark Initializations

+ (instancetype)defaultService {
    static CoreService *service = nil;
    static dispatch_once_t serviceOnceToken;
    dispatch_once(&serviceOnceToken, ^{
        service = [[[self class] alloc] init];
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

/* default property set */
- (void)initDefaults {
    netModeLockObject = [[NSObject alloc] init];
    
    _state_ = ServiceStateClosed;
    _netMode_ = NetModeNone;
    
    _needRefreshUnit_ = YES;
    
    mayUsingInternalNetModeCommands = [NSArray arrayWithObjects:COMMAND_KEY_CONTROL, COMMAND_GET_CAMERA_SERVER, COMMAND_GET_SENSORS, nil];
    usingRestfulForAnyNetModeCommands = [NSArray arrayWithObjects:COMMAND_GET_SENSORS, nil];
        
    /* Network monitor */
    reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self startMonitorNetworks];
}

#pragma mark -
#pragma mark Execute device command

/*
 *
 * 执行Device Command
 *.
 * 无网络                   ---> RETURN
 * 3G                      ---> Using TCP CONNECTION
 * WIFI  WITH UNIT         ---> Using RESTFUL SERVICE
 * WIFI  WITH NO UNIT      ---> Using TCP CONNECTION
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    // ******* 不能在主线程在执行命令
    // 统一使用CoreService 所在的线程收发命令
    
    // 如果当前线程就是 CoreService 线程 直接执行
    if([self coreServiceThread] == [NSThread currentThread]) {
        [self executeDeviceCommandInternal:command];
    } else {
        // 当前线程不是Core Service所在线程, 把其 丢到Core Service 的Runloop 中去
        @synchronized(self) {
            [self performSelector:@selector(executeDeviceCommandInternal:) onThread:[self coreServiceThread] withObject:command waitUntilDone:NO];
        }
    }
}

- (void)executeDeviceCommandInternal:(DeviceCommand *)command {
    
    if(_state_ != ServiceStateOpenned) {
#ifdef DEBUG
//        NSLog(@"[Core Service] Service is not ready, [%@] can't be executed.", command.commandName);
#endif
        return;
    }
    
    /* 找到最适合Device Command 的 Executor */
    id<CommandExecutor> executor = [self determineCommandExcutor:command];
    if(executor != nil) {
#ifdef DEBUG
        if(![COMMAND_SEND_HEART_BEAT isEqualToString:command.commandName]) {
            NSLog(@"[Core Service] 使用 [%@] 执行 [%@] 命令", [executor executorName], command.commandName);
        }
#endif
        [executor executeCommand:command];
    } else {
#ifdef DEBUG
//        NSLog(@"[Core Service] Executor not found, [%@] can't be executed.", command.commandName);
#endif
    }
}

- (void)queueCommand:(DeviceCommand *)command {
#ifdef DEBUG
    NSLog(@"[Core Service] [%@] 命令已加入队列", command.commandName);
#endif
    [self.tcpService queueCommand:command];
}

- (id<CommandExecutor>)determineCommandExcutor:(DeviceCommand *)command {
    /*
     * 如果Device Command 明确指定了其执行的网络模式
     *
     */
    if(CommandNetworkModeInternal == command.commandNetworkMode
       || CommandNetworkModeExternalViaRestful == command.commandNetworkMode) {
        return self.restfulService;
    } else if(CommandNetworkModeExternalViaTcpSocket == command.commandNetworkMode) {
        return self.tcpService;
    }
    
    /*
     * 检查Device Command 是不是一个内网命令
     */
    if([self commandCanDeliveryInInternalNetMode:command]) {
        // 并且当前同时有内网
        if((self.netMode & NetModeInternal) == NetModeInternal) {
            command.commandNetworkMode = CommandNetworkModeInternal;
            return self.restfulService;
        }
    }
    
    // 到这里说明了Device Command 不是一个内网命令 或者 当前没有内网
    // 检查此 Command 是否要走 外网的 Rest
    if([self isRestfulCommandInAnyNetModes:command]) {
        command.commandNetworkMode = CommandNetworkModeExternalViaRestful;
        return self.restfulService;
    }
    
    // 有外网Socket连接 那么就使用外网Socket 通讯
    if((self.netMode & NetModeExtranet) == NetModeExtranet) {
        command.commandNetworkMode = CommandNetworkModeExternalViaTcpSocket;
        return self.tcpService;
    }
    
    return nil;
}

- (BOOL)commandCanDeliveryInInternalNetMode:(DeviceCommand *)command {
    if(mayUsingInternalNetModeCommands == nil) return NO;
    /* 
     * 这是一个特殊的命令 要单独进行判断
     * 获取当个主控信息可以内网 也可以是外网
     * 获取所有的主控列表(也就是不传 masterDeviceCode) 只能走外网
     * 但是还有一种情况不传 masterDeviceCode 但是要走内网 (自动发现的时候是没有masterDeviceCode的, 只有一个unitServerUrl)
     *
     */
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        if([XXStringUtils isBlank:command.masterDeviceCode]) {
            DeviceCommandGetUnit *cmd = (DeviceCommandGetUnit *)command;
            return ![XXStringUtils isBlank:cmd.unitServerUrl];
        } else {
            return YES;
        }
    }
    
    for(int i=0; i<mayUsingInternalNetModeCommands.count; i++) {
        NSString *cmdName = [mayUsingInternalNetModeCommands objectAtIndex:i];
        if([cmdName isEqualToString:command.commandName]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isRestfulCommandInAnyNetModes:(DeviceCommand *)command {
    if(usingRestfulForAnyNetModeCommands == nil) return NO;
    
    for(int i=0; i<usingRestfulForAnyNetModeCommands.count; i++) {
        NSString *cmdName = [usingRestfulForAnyNetModeCommands objectAtIndex:i];
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
    
#ifdef DEBUG
    NSString *networkModeString = [XXStringUtils emptyString];
    if(command.commandNetworkMode == CommandNetworkModeExternalViaRestful
        || command.commandNetworkMode == CommandNetworkModeExternalViaTcpSocket) {
        networkModeString = @"外网";
    } else if(command.commandNetworkMode == CommandNetworkModeInternal) {
        networkModeString = @"内网";
    }
    NSLog(@"[Core Service] 收到来自 [%@] 的 [%@]命令", networkModeString, command.commandName);
#endif
    
    // Security key 错了或者过期了 必须踢出去
    if(command.resultID == -3000 || command.resultID == -2000 || command.resultID == -1000) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Shared shared].app logout];
            return;
        });
    }
    
    // 如果Result ID == - 100 ,我们定义的意思是忽略这个 Command
    // 不需要对齐做任何处理
    if(command.resultID == -100) return;
    
    // 如果服务未打开 也忽略它
    if(_state_ != ServiceStateOpenned) {
#ifdef DEBUG
        NSLog(@"[Core Service] 服务未开启不能处理 [%@] 命令", command.commandName);
#endif
        return;
    }
    
    DeviceCommandHandler *handler = nil;
    
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetUnitsHandler alloc] init];
    } else if([COMMAND_GET_SENSORS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetSensorsHandler alloc] init];
    } else if([COMMAND_PUSH_DEVICE_STATUS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateDevicesHandler alloc] init];
    } else if([COMMAND_GET_ACCOUNT isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetAccountHandler alloc] init];
    } else if([COMMAND_PUSH_NOTIFICATIONS isEqualToString:command.commandName] || [COMMAND_GET_NOTIFICATIONS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetNotificationsHandler alloc] init];
    } else if([COMMAND_CHANGE_UNIT_NAME isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateUnitNameHandler alloc] init];
    } else if([COMMAND_GET_SCORE isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetScoreHandler alloc] init];
    }
    
    if(handler != nil) {
        [handler handle:command];
    }
}

#pragma mark -
#pragma mark Event Subscriber

// 此Service 也是事件的订阅者
- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    // 收到了命令
    if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *commandReceivedEvent = (DeviceCommandEvent *)event;
        [self handleDeviceCommand:commandReceivedEvent.command];
    
    // 切换了当前主控
    } else if([event isKindOfClass:[CurrentUnitChangedEvent class]]) {
        CurrentUnitChangedEvent *unitChangedEvent = (CurrentUnitChangedEvent *)event;
#ifdef DEBUG
        // trigger source 代表以何种方式切换主控的
        // 通过命令或者手动切换或者从硬盘读取
        NSString *triggerSource = [XXStringUtils emptyString];
        if(unitChangedEvent.triggeredSource == TriggeredByGetUnitsCommand) {
            triggerSource = @"命令";
        } else if(unitChangedEvent.triggeredSource == TriggeredByManual) {
            triggerSource = @"用户手动切换";
        } else if(unitChangedEvent.triggeredSource == TriggeredByReadDisk) {
            triggerSource = @"从手机硬盘读取文件";
        }
        NSLog(@"[Core Service] 当前主控切换到 [%@] 通过 [%@] 方式触发的", unitChangedEvent.unitIdentifier, triggerSource);
#endif
        if(![XXStringUtils isBlank:unitChangedEvent.unitIdentifier]) {
            [self fireTaskTimer];
        }
    }
}

//
- (NSString *)xxEventSubscriberIdentifier {
    return @"deviceCommandDeliveryServiceSubscriber";
}

#pragma mark -
#pragma mark Open or Stop Core Service

- (void)startService {
    if([NSThread currentThread] == [self coreServiceThread]) {
        [self startServiceInternal];
    } else {
        [self performSelector:@selector(startServiceInternal) onThread:[self coreServiceThread] withObject:nil waitUntilDone:YES];
    }
}

- (void)startServiceInternal {
    if(_state_ != ServiceStateOpenned && _state_ != ServiceStateOpenning) {
#ifdef DEBUG
        NSLog(@"[Core Service] 服务在 [%@] 线程上准备开启", [NSThread currentThread].name);
#endif
        // 正在打开服务
        _state_ = ServiceStateOpenning;
        
        // 订阅事件
        XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventNames:[NSArray arrayWithObjects:EventDeviceCommand, EventCurrentUnitChanged, nil]]];
        [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
        
        // 从硬盘加载所有Units
        [[UnitManager defaultManager] loadUnitsFromDisk];
        
        // 服务已经启动
        _state_ = ServiceStateOpenned;
        
#ifdef DEBUG
        NSLog(@"[Core Service] 服务在 [%@] 线程上已启动", [NSThread currentThread].name);
#endif
    }
}

- (void)stopService {
    /*
     * 必须用主线程来关闭服务, why? no why
     */
    if([NSThread currentThread].isMainThread) {
        [self stopServiceInternal];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self stopServiceInternal];
        });
    }
}

- (void)stopServiceInternal {
    if(_state_ != ServiceStateClosed && _state_ != ServiceStateClosing) {
        _state_ = ServiceStateClosing;
#ifdef DEBUG
        NSLog(@"[Core Service] 服务准备在 [%@] 线程上关闭",
              [NSThread currentThread].isMainThread ? @"Main Thread" : [NSThread currentThread].name);
#endif
        
        [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
        
        // 断开TCP
        [self.tcpService disconnect];
        
        // 把内存数据写入硬盘
        [[UnitManager defaultManager] syncUnitsToDisk];
      
        _state_ = ServiceStateClosed;
        
#ifdef DEBUG
        NSLog(@"[Core Service] 服务关闭于 [%@] 线程",
              [NSThread currentThread].isMainThread ? @"Main Thread" : [NSThread currentThread].name);
#endif
    }
}

#pragma mark -
#pragma mark TCP Connection checker

- (void)checkTcp {
    if(self.state != ServiceStateOpenned) {
#ifdef DEBUG
        NSLog(@"[Core Service] 服务未开启不能检查 TCP 连接");
#endif
        return;
    }
    [self startTcpIfNeed];
}

- (void)startTcpIfNeed {
    if(!self.tcpService.isConnecttingOrConnectted) {
        [self.tcpService connect];
    }
}

- (void)doTimerTask {
    if(self.state != ServiceStateOpenned) {
#ifdef DEBUG
//        NSLog(@"[Core Service] Timer task can't be executed, because core service is not openned.");
#endif
        return;
    }
    
#ifdef DEBUG
    //NSLog(@"[Core Service] Timer task On Thread [%@].", [NSThread currentThread].name);
#endif
    
    // Send heart beat command
    [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeSendHeartBeat]];
    
    Unit *unit = [UnitManager defaultManager].currentUnit;
    if(unit != nil) {
        // 这是一个同步方法  必须先完成这步才能往下走  不同于 'checkInternalOrNotInternalNetwork' 异步的
        [self checkIsReachableInternalUnit];
        
        if(self.needRefreshUnit) {
            DeviceCommand *command = [CommandFactory commandForType:CommandTypeGetUnits];
            command.masterDeviceCode = unit.identifier;
            command.hashCode = unit.hashCode;
            [self executeDeviceCommand:command];
            
            // 拿当前主控的传感器设备信息(pm2.5 等)
            DeviceCommand *getSensorsCommand = [CommandFactory commandForType:CommandTypeGetSensors];
            getSensorsCommand.masterDeviceCode = unit.identifier;
            [self executeDeviceCommand:getSensorsCommand];
        }

        [self updateScoreForUnit:unit];
    }
    
    // 更新当前location 以及 AQI 信息
    // 可以放心的调用 因为时间间隔少于1小时 不会有真正的调用
    [[AQIManager manager] mayUpdateAqi];
}

- (void)fireTaskTimer {
    if(refreshTaskTimer != nil) {
        if([NSThread currentThread] == [self coreServiceThread]) {
            [self fireTaskTimerInternal];
        } else {
            [self performSelector:@selector(fireTaskTimerInternal) onThread:[self coreServiceThread] withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)fireTaskTimerInternal {
    [refreshTaskTimer fire];
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
            // ignore else
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
            self.netMode = NetModeNone;
        } else {
            if(self.tcpService.isConnectted) {
                [self addNetMode:NetModeExtranet];
            } else {
                [self removeNetMode:NetModeExtranet];
            }
        }
    }
}

- (void)checkInternalOrNotInternalNetwork {
    dispatch_async(networkModeCheckTaskQueue(), ^{
        [self checkIsReachableInternalUnit];
    });
}

- (void)checkIsReachableInternalUnit {
    if([UnitManager defaultManager].currentUnit == nil) return;
    if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable) {
        // 没有WIFI
        self.netMode = self.tcpService.isConnectted ? NetModeExtranet : NetModeNone;
        return;
    }
    
    // 有wifi, 检查当前主控是否在内网模式
    
    NSString *url = [NSString stringWithFormat:@"http://%@/heartbeat",
                     [UnitManager defaultManager].currentUnit.localIP];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:HEART_BEAT_TIMEOUT];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error == nil) {
        if(response) {
            NSHTTPURLResponse *rp = (NSHTTPURLResponse *)response;
            if(rp.statusCode == 200 && data != nil) {
                NSString *unitIdentifier = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                Unit *currentUnit = [UnitManager defaultManager].currentUnit;
                if(currentUnit != nil) {
                    if([currentUnit.identifier isEqualToString:unitIdentifier]) {
                        // 有内网, 给当前网络状态增加一个内网模式
                        [self addNetMode:NetModeInternal];
                        return;
                    }
                }
            }
        }
    }
    // 没有内网
    // 当前网络状态需要把内网模式移出出去
    [self removeNetMode:NetModeInternal];
}

- (void)addNetMode:(NetMode)netMode {
    @synchronized(netModeLockObject) {
        if((_netMode_ & netMode) == NetModeNone) {
            // new netMode which will added doesn't exists
            _netMode_ |= netMode;
            [self notifyNetModeChanged];
        }
    }
}

- (void)removeNetMode:(NetMode)netMode {
    @synchronized(netModeLockObject) {
        if((_netMode_ & netMode) == netMode) {
            // new netMode which will removed has exists
            _netMode_ = ~(~_netMode_ | netMode);
            [self notifyNetModeChanged];
        }
    }
}

- (void)setNetMode:(NetMode)netMode {
    @synchronized(netModeLockObject) {
        if(_netMode_ != netMode) {
            _netMode_ = netMode;
            [self notifyNetModeChanged];
        }
    }
}

- (NetMode)netMode {
    @synchronized(netModeLockObject) {
        return _netMode_;
    }
}

- (void)notifyNetModeChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
#ifdef DEBUG
        NSString *netModeString = [XXStringUtils emptyString];
        NetMode nm = self.netMode;
        if(nm == NetModeNone) {
            netModeString = @"没有网络模式";
        } else if(nm == NetModeExtranet) {
            netModeString = @"外网模式";
        } else if(nm == NetModeInternal) {
            netModeString = @"内网模式";
        } else if(nm == NetModeAll) {
            netModeString = @"内外网共存模式";
        }
        NSLog(@"[Core Service] 当前网络模式切换到 [%@]", netModeString);
#endif
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:
            [[NetworkModeChangedEvent alloc] initWithNetMode:self.netMode]];
    });
}

- (void)updateScoreForUnit:(Unit *)unit {
    NSNumber *score = [ScoringTools scoringForUnit:unit];
    if(score != nil) {
        float ranking = [ScoringTools rankingForScore:score.floatValue];
        DeviceCommandGetScore *mockReceivedGetUnitScoreCommand = [[DeviceCommandGetScore alloc] init];
        mockReceivedGetUnitScoreCommand.commandName = COMMAND_GET_SCORE;
        mockReceivedGetUnitScoreCommand.masterDeviceCode = unit.identifier;
        mockReceivedGetUnitScoreCommand.score = score.intValue;
        mockReceivedGetUnitScoreCommand.rankings = ranking;
        DeviceCommandGetScoreHandler *handler = [[DeviceCommandGetScoreHandler alloc] init];
        [handler handle:mockReceivedGetUnitScoreCommand];
#ifdef DEBUG
        NSLog(@"[Core Service] Score %.0f, ranking %.0f for unit %@", score.floatValue, ranking, unit.identifier);
#endif
    } else {
#ifdef DEBUG
        NSLog(@"[Core Service] No score ...");
#endif
    }
    /*
        DeviceCommand *getScoreCommand = [CommandFactory commandForType:CommandTypeGetScore];
        getScoreCommand.masterDeviceCode = unit.identifier;
        [self executeDeviceCommand:getScoreCommand]; 
    */
}

- (void)notifyTcpConnectionOpened {
    [self addNetMode:NetModeExtranet];
    
    // 判断是否有必要发送 Get Units Command,
    // 如果时间间隔不是很长就没必要发送
    NSDate *lastExecuteDate = [GlobalSettings defaultSettings].getUnitsCommandLastExecuteDate;
    
    if(lastExecuteDate != nil && [UnitManager defaultManager].units.count > 0) {
        NSTimeInterval lastExecuteMinutesSinceNow = abs(lastExecuteDate.timeIntervalSinceNow) / 60.f;
        if(lastExecuteMinutesSinceNow >= GETUNITS_MINITES_INTERVAL) {
#ifdef DEBUG
            NSLog(@"[Core Service] 准备获取所有主控列表,  距离上次获取 %.2f 分钟", lastExecuteMinutesSinceNow);
#endif
            [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
        } else {
            #ifdef DEBUG
                NSLog(@"[Core Service] 无须获取所有主控列表,  距离上次获取 %.2f 分钟", lastExecuteMinutesSinceNow);
            #endif
        }
    } else {
#ifdef DEBUG
        NSLog(@"[Core Service] 准备 首次 获取所有主控列表");
#endif
        [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
    }
    
    // Get notifications
    [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetNotifications]];
}

- (void)notifyTcpConnectionClosed {
    [self removeNetMode:NetModeExtranet];
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