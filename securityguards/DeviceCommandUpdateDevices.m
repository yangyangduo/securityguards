//
//  DeviceCommandUpdateDevices.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateDevices.h"
#import "DeviceStatus.h"

@implementation DeviceCommandUpdateDevices

@synthesize voiceText;
@synthesize devicesStatus;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self && json) {
        self.voiceText = [json stringForKey:@"voiceText"];
        NSArray *_devices_ = [json arrayForKey:@"childDeviceStatuses"];
        if(_devices_ != nil) {
            for(NSDictionary *_device_ in _devices_) {
                [self.devicesStatus addObject:[[DeviceStatus alloc] initWithJson:_device_]];
            }
        }
    }
    return self;
}

- (NSMutableArray *)devicesStatus {
    if(devicesStatus == nil) {
        devicesStatus = [NSMutableArray array];
    }
    return devicesStatus;
}

@end
