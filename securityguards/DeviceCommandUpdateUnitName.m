//
//  DeviceCommandUpdateUnitName.m
//  SmartHome
//
//  Created by Zhao yang on 9/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitName.h"

@implementation DeviceCommandUpdateUnitName

@synthesize name;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    [json setMayBlankString:self.name forKey:@"name"];
    return json;
}

@end
