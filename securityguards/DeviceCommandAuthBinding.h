//
//  DeviceCommandAuthBinding.h
//  SmartHome
//
//  Created by Zhao yang on 9/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface DeviceCommandAuthBinding : DeviceCommand

@property (strong, nonatomic) NSString *requestDeviceCode;

@end
