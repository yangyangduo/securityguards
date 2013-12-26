//
//  DeviceCommandAuthBinding.m
//  SmartHome
//
//  Created by Zhao yang on 9/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandAuthBinding.h"

@implementation DeviceCommandAuthBinding

@synthesize requestDeviceCode;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    if(json) {
        [json setMayBlankString:self.requestDeviceCode forKey:@"requestDeviceCode"];
        [json setInteger:self.resultID forKey:@"resultId"];
    }
    return json;
}

@end
