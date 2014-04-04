//
//  SensorData.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SensorData.h"

@implementation SensorData

@synthesize unit;
@synthesize unitSymbol;
@synthesize value;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.unit = [json noNilStringForKey:@"un"];
        self.unitSymbol = [json noNilStringForKey:@"us"];
        self.value = (float)[json doubleForKey:@"vl"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.unit forKey:@"un"];
    [json setMayBlankString:self.unitSymbol forKey:@"us"];
    [json setDouble:self.value forKey:@"vl"];
    return json;
}

@end
