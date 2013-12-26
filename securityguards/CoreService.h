//
//  CoreService.h
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  Command Executor */
#import "TCPCommandService.h"
#import "RestfulCommandService.h"

#import "CommandFactory.h"
#import "XXEventSubscriber.h"
#import "Reachability.h"

typedef NS_ENUM(NSUInteger, ServiceState) {
    ServiceStateClosed,
    ServiceStateOpenning,
    ServiceStateOpenned,
    ServiceStateClosing
};

typedef NS_ENUM(NSUInteger, NetworkMode) {
    NetworkModeNotChecked,
    NetworkModeExternal,
    NetworkModeInternal
};

@interface CoreService : NSObject<XXEventSubscriber>

@property (strong, nonatomic, readonly) TCPCommandService *tcpService;
@property (strong, nonatomic, readonly) RestfulCommandService *restfulService;
@property (assign, nonatomic, readonly) ServiceState state;

/*
 
 In method of startRefreshCurrentUnit
 if the flag is NO only check network and send heartbeat message
 if the flag is YES also refresh unit and scene modes
 the default value is YES
 
 */
@property (assign, nonatomic) BOOL needRefreshUnit;

+ (CoreService *)defaultService;

/* Start or stop command delivery service */
- (void)startService;
- (void)stopService;

/* Execute device command */
- (void)executeDeviceCommand:(DeviceCommand *)command;

/*
   It's different from 'executeDeviceCommand'
   If the service or tcp connection is not open, execute device command will not 
   really execute the command, and you can use 'queueCommand' to execute the device command
   when the service or tcp connection is ready
 */
- (void)queueCommand:(DeviceCommand *)command;

/* Network mode */

- (NetworkMode)currentNetworkMode;
- (void)setCurrentNetworkMode:(NetworkMode)mode;
- (void)checkInternalOrNotInternalNetwork;

/* Start and Stop refresh current unit */
- (void)startRefreshCurrentUnit;
- (void)stopRefreshCurrentUnit;
- (void)fireRefreshUnit;

- (void)notifyTcpConnectionOpened;
- (void)notifyTcpConnectionClosed;

@end
