//
//  DeviceCommandEvent.h
//  SmartHome
//
//  Created by Zhao yang on 12/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "CommandFactory.h"
#import "EventNameContants.h"

@interface DeviceCommandEvent : XXEvent

@property (strong, nonatomic, readonly) DeviceCommand *command;

- (id)initWithDeviceCommand:(DeviceCommand *)command;

@end
