//
//  DeviceStatusChangedEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceStatusChangedEvent.h"

@implementation DeviceStatusChangedEvent

@synthesize command = _command_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventDeviceStatusChanged;
    }
    return self;
}

- (id)initWithCommand:(DeviceCommandUpdateDevices *)command {
    self = [self init];
    if(self) {
        _command_ = command;
    }
    return self;
}

@end
