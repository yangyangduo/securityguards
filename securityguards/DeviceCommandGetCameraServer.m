//
//  DeviceCommandGetCameraServer.m
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetCameraServer.h"

@implementation DeviceCommandGetCameraServer

@synthesize cameraId;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        self.cameraId = [json stringForKey:@"cameraId"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    if(json) {
        [json setMayBlankString:self.cameraId forKey:@"cameraId"];
    }
    return json;
}

@end
