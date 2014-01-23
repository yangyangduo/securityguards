//
//  DeviceCommandReceivedSensors.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "Sensor.h"

@interface DeviceCommandReceivedSensors : DeviceCommand

@property (nonatomic, strong) NSMutableArray *sensors;

@end
