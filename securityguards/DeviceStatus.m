//
//  DeviceStatus.m
//  SmartHome
//
//  Created by Zhao yang on 9/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceStatus.h"

@implementation DeviceStatus

@synthesize state;
@synthesize status;
@synthesize deviceIdentifer;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.deviceIdentifer = [json stringForKey:@"code"];
        self.status = [json integerForKey:@"status"];
        self.state = [json integerForKey:@"state"];
    }
    return self;
}

@end
