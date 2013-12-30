//
//  TCPCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TCPCommandService.h"
#import "XXEventSubscriptionPublisher.h"
#import "XXEventNameFilter.h"
#import "EventNameContants.h"
#import "CommandFactory.h"
#import "CoreService.h"
#import "DeviceCommandEvent.h"
#import "GlobalSettings.h"
#import "AccountService.h"
#import "Shared.h"

@implementation TCPCommandService {
    ExtranetClientSocket *socket;
    CommandQueue *queue;
    
    NSUInteger failureCount;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(queue == nil) {
        queue = [[CommandQueue alloc] init];
    }
    failureCount = 0;
}

- (void)connect {
    @synchronized(self) {
        NSString *tcpAddress = [GlobalSettings defaultSettings].tcpAddress;
        NSArray *addressSet = [tcpAddress componentsSeparatedByString:@":"];
        
        if(addressSet == nil || addressSet.count != 2) {
    #ifdef DEBUG
            NSLog(@"[TCP COMMAND SOCKET] Server address error [ %@ ]", tcpAddress == nil ? [XXStringUtils emptyString] : tcpAddress);
    #endif
            return;
        }
        
        NSString *addr = [addressSet objectAtIndex:0];
        NSString *port = [addressSet objectAtIndex:1];
        socket = [[ExtranetClientSocket alloc] initWithIPAddress:addr andPort:port.integerValue];
        socket.messageHandlerDelegate = self;
        
        [self performSelectorInBackground:@selector(connectInternal) withObject:nil];
    }
}

- (void)connectInternal {
    [socket connect];
}

- (void)disconnect {
    @synchronized(self) {
        if(socket != nil) {
            [socket close];
            socket.messageHandlerDelegate = nil;
            socket = nil;
        }
    }
}

- (BOOL)isConnectted {
    @synchronized(self) {
        if(socket == nil) return NO;
        return socket.isConnectted;
    }
}

- (BOOL)isConnectting {
    @synchronized(self) {
        if(socket == nil) return NO;
        return socket.isConnectting;
    }
}

- (BOOL)isConnecttingOrConnectted {
    @synchronized(self) {
        if(socket == nil) return NO;
        return socket.isConnectting || socket.isConnectted;
    }
}

#pragma mark -
#pragma mark Exeutor Implementations

- (void)queueCommand:(DeviceCommand *)command {
    [self executeCommand:command];
}

- (void)executeCommand:(DeviceCommand *)command {
    if(![queue contains:command]) {
        [queue pushCommand:command];
        [self flushQueue];
    }
}

- (NSString *)executorName {
    return @"TCP SERVICE";
}

/* Send all of device commands queue to server */
- (void)flushQueue {
    @synchronized(self) {
        if(socket != nil && socket.isConnectted && socket.canWrite && queue.count > 0) {
            NSMutableData *dataToSender = [NSMutableData data];
            DeviceCommand *command = [queue popup];
            while (command != nil) {
                CommunicationMessage *message = [[CommunicationMessage alloc] init];
                message.deviceCommand = command;
                NSData *data = [message generateData];
                if(data != nil) {
                    [dataToSender appendData:data];
                }
                command = [queue popup];
            }
            if(dataToSender.length > 0) {
                [socket writeData:dataToSender];
            }
        }
    }
}

#pragma mark -
#pragma mark Refresh tcp address

- (void)refreshTcpAddress {
    AccountService *accountService = [[AccountService alloc] init];
    [accountService relogin:@selector(reloginSuccess:) failed:@selector(reloginFailed:) target:self callback:nil];
}

- (void)reloginSuccess:(RestResponse *)resp {
    if(resp != nil && resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *result = [json stringForKey:@"id"];
            if(![XXStringUtils isBlank:result]) {
                if([@"1" isEqualToString:result]) {
                    NSString *tcp = [json stringForKey:@"tcp"];
                    if(![XXStringUtils isBlank:tcp]) {
#ifdef DEBUG
                        NSLog(@"[COMMAND SERVICE] Get new tcp address [%@].", tcp);
#endif
                        [GlobalSettings defaultSettings].tcpAddress = tcp;
                        [[GlobalSettings defaultSettings] saveSettings];
                    }
                    return;
                } else if([@"-3000" isEqualToString:result]) {
                    [[Shared shared].app logout];
                    return;
                }
            }
        }
    }
    [self reloginFailed:resp];
}

- (void)reloginFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[COMMAND SERVICE] Refresh tcp address failed, status code is %d", resp.statusCode);
#endif
}


#pragma mark -
#pragma mark Message Handler

- (void)clientSocketSenderReady {
    [self flushQueue];
}

- (void)clientSocketMessageDiscard:(NSData *)discardMessage {
#ifdef DEBUG
    NSLog(@"[TCP COMMAND SOCKET] Some data will discard, the length is %d", discardMessage.length);
#endif
}

- (void)clientSocketMessageReadError {
#ifdef DEBUG
    NSLog(@"[TCP COMMAND SOCKET] Socket data reading or format error");
#endif
}

- (void)clientSocketWithReceivedMessage:(NSData *)messages {
//#ifdef DEBUG
//    NSLog(@"%@", [[NSString alloc] initWithData:messages encoding:NSUTF8StringEncoding]);
//#endif
    DeviceCommand *command = [CommandFactory commandFromJson:[JsonUtils createDictionaryFromJson:messages]];
    command.commmandNetworkMode = CommandNetworkModeExternal;
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[DeviceCommandEvent alloc] initWithDeviceCommand:command]];
}

- (void)notifyConnectionClosed {
#ifdef DEBUG
    NSLog(@"[TCP COMMAND SOCKET] Closed.");
#endif
    [[CoreService defaultService] notifyTcpConnectionClosed];

}

- (void)notifyConnectionOpened {
#ifdef DEBUG
    NSLog(@"[TCP COMMAND SOCKET] Opened.");
#endif
    [[CoreService defaultService] notifyTcpConnectionOpened];
}

- (void)notifyConnectionTimeout {
#ifdef DEBUG
    NSLog(@"[TCP COMMAND SOCKET] Connect timeout.");
#endif
    [self refreshTcpAddress];
}

@end
