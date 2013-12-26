//
//  DeviceCommandReceivedCameraServer.m
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandReceivedCameraServer.h"

@implementation DeviceCommandReceivedCameraServer

@synthesize cameraId;
@synthesize conStr;
@synthesize server;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        self.cameraId = [json stringForKey:@"cameraId"];
        self.conStr = [json stringForKey:@"conStr"];
        self.server = [json stringForKey:@"server"];
    }
    return self;
}

@end
