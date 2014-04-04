//
//  Sensor.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Sensor.h"

@implementation Sensor

@synthesize identifier;
@synthesize sensorDataType;
@synthesize sensorType;
@synthesize data;

@synthesize isHumiditySensor;
@synthesize isPM25Sensor;
@synthesize isTempureSensor;
@synthesize isVOCSensor;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.identifier = [json noNilStringForKey:@"si"];
        self.sensorDataType = [json noNilStringForKey:@"st"];
        self.sensorType = [json noNilStringForKey:@"ty"];
        self.data = [[SensorData alloc] initWithJson:[json dictionaryForKey:@"da"]];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    [json setMayBlankString:self.identifier forKey:@"si"];
    [json setMayBlankString:self.sensorDataType forKey:@"st"];
    [json setMayBlankString:self.sensorType forKey:@"ty"];
    [json setNoNilObject:[self.data toJson] forKey:@"da"];
    
    return json;
}

- (BOOL)isVOCSensor {
    return [@"voc" isEqualToString:self.sensorType];
}

- (BOOL)isTempureSensor {
    return [@"wd" isEqualToString:self.sensorType];
}

- (BOOL)isHumiditySensor {
    return [@"sd" isEqualToString:self.sensorType];
}

- (BOOL)isPM25Sensor {
    return [@"pm" isEqualToString:self.sensorType];
}

@end
