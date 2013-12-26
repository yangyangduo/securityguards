//
//  DeviceCommandReceivedCameraServer.h
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface DeviceCommandReceivedCameraServer : DeviceCommand

@property (strong, nonatomic) NSString *cameraId;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *conStr;

@end
