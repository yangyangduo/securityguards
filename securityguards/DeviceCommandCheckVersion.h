//
//  DeviceCommandCheckVersion.h
//  SmartHome
//
//  Created by hadoop user account on 23/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface DeviceCommandCheckVersion : DeviceCommand

@property (strong,nonatomic) NSNumber *curVersion;

@end
