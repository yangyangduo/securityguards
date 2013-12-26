//
//  DeviceStatusChangedEvent.h
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "DeviceCommandUpdateDevices.h"
#import "EventNameContants.h"

@interface DeviceStatusChangedEvent : XXEvent

@property (strong, nonatomic, readonly) DeviceCommandUpdateDevices *command;

- (id)initWithCommand:(DeviceCommandUpdateDevices *)command;

@end
