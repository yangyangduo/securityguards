//
//  DeviceCommandCheckVersion.m
//  SmartHome
//
//  Created by hadoop user account on 23/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandCheckVersion.h"

@implementation DeviceCommandCheckVersion

@synthesize curVersion;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    if(json) {
        [json setObject:self.curVersion forKey:@"curVersion"];
    }
    return json;
}

@end
