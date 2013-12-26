//
//  DeviceCommandUpdateDeviceToken.m
//  SmartHome
//
//  Created by Zhao yang on 10/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateDeviceToken.h"

@implementation DeviceCommandUpdateDeviceToken

@synthesize iosToken;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    if(json) {
        [json setMayBlankString:self.iosToken forKey:@"iosToken"];
    }
    return json;
}

@end
