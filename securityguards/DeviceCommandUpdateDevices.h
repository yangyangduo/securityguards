//
//  DeviceCommandUpdateDevices.h
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface DeviceCommandUpdateDevices : DeviceCommand

@property (strong, nonatomic) NSString *voiceText;
@property (strong, nonatomic) NSMutableArray *devicesStatus;

@end
