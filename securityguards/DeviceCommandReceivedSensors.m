//
//  DeviceCommandReceivedSensors.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceCommandReceivedSensors.h"

@implementation DeviceCommandReceivedSensors

@synthesize sensors = _sensors_;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self && json) {
        NSArray *_j_sensors_ = [json arrayForKey:@"m"];
        if(_j_sensors_ != nil) {
            for(int i=0; i<_j_sensors_.count; i++) {
                NSDictionary *_sensor_ = [_j_sensors_ objectAtIndex:i];
                [self.sensors addObject:
                    [[Sensor alloc] initWithJson:_sensor_]];
            }
        }
    }
    return self;
}

- (NSMutableArray *)sensors {
    if(_sensors_ == nil) {
        _sensors_ = [NSMutableArray array];
    }
    return _sensors_;
}

@end
