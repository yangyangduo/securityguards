//
//  DeviceCommandUpdateDevice.h
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface DeviceCommandUpdateDevice : DeviceCommand

@property (strong, nonatomic) NSMutableArray *executions;

- (void)addCommandString:(NSString *)commandStr;

@end
