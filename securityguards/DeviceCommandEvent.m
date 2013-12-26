//
//  DeviceCommandEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandEvent.h"

@implementation DeviceCommandEvent

@synthesize command = _command_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventDeviceCommand;
    }
    return self;
}

- (id)initWithDeviceCommand:(DeviceCommand *)command {
    self = [self init];
    if(self) {
        _command_ = command;
    }
    return self;
}

@end
