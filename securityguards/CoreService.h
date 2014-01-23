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


typedef enum {
    NetModeNone     = 0,
    NetModeExtranet = 1 << 0,
    NetModeInternal = 1 << 1,
    NetModeAll      = NetModeInternal | NetModeExtranet,
} NetMode;

/*
 * Core service in running in a background thread named "CoreServiceThread"
 */
@interface CoreService : NSObject<XXEventSubscriber>

@property (strong, nonatomic, readonly) TCPCommandService *tcpService;
@property (strong, nonatomic, readonly) RestfulCommandService *restfulService;
@property (assign, nonatomic, readonly) ServiceState state;

@property (nonatomic) NetMode netMode;

/*
 
 In method of startRefreshCurrentUnit
 if the flag is NO only check network and send heartbeat message
 if the flag is YES also refresh unit and scene modes
 the default value is YES
 
 */
@property (assign, nonatomic) BOOL needRefreshUnit;

/*  A Thread Run Background Used For Core Service Around All App Life  */
- (NSThread *)coreServiceThread;

/*   Singleton   */
+ (instancetype)defaultService;

/*   Start Core Service   */
- (void)startService;

/*   Stop  Core Service   */
- (void)stopService;

/* Execute Device Command */
- (void)executeDeviceCommand:(DeviceCommand *)command;

/*
   It's different from 'executeDeviceCommand'
   If the service or tcp connection is not open, execute device command will not 
   really execute the command, and you can use 'queueCommand' to execute the device command
   when the service or tcp connection is ready
 */
- (void)queueCommand:(DeviceCommand *)command;

/*
 *
 * Here is task timer to do:
 *
 * [ send heart beat message ]
 * [ send asyn task on serial queue to check network state (Interal or External) ]
 * [ refresh unit list via device command]
 * [ refresh sensors via rest api]
 *
 * This method is immediately to execute the timer
 *
 */
- (void)fireTaskTimer;


/* Net Mode */

- (void)addNetMode:(NetMode)netMode;
- (void)removeNetMode:(NetMode)netMode;
- (void)checkInternalOrNotInternalNetwork;


/* Belows two method will move to our new event system later */
- (void)notifyTcpConnectionOpened;
- (void)notifyTcpConnectionClosed;

@end
