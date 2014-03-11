//
//  AQIDetail.m
//  securityguards
//
//  Created by Zhao yang on 2/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AQIDetail.h"

@implementation AQIDetail

@synthesize aqiNumber;
@synthesize area;
@synthesize quality;
@synthesize tips;
@synthesize updateTime;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        NSDictionary *_m_ = [json dictionaryForKey:@"m"];
        if(_m_ != nil) {
            self.aqiNumber = [_m_ intForKey:@"aqi"];
            self.quality = [_m_ noNilStringForKey:@"quality"];
            self.area = [_m_ noNilStringForKey:@"area"];
            self.updateTime = [_m_ dateWithMillisecondsForKey:@"time_point"];
        } else {
            self.aqiNumber = 0;
            self.quality = [XXStringUtils emptyString];
            self.area = [XXStringUtils emptyString];
            self.updateTime = nil;
        }
        self.tips = [json noNilStringForKey:@"d"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];

    NSMutableDictionary *aqiBody = [NSMutableDictionary dictionary];
    [aqiBody setInteger:self.aqiNumber forKey:@"aqi"];
    [aqiBody setDateWithMilliseconds:self.updateTime forKey:@"time_point"];
    [aqiBody setMayBlankString:self.quality forKey:@"quality"];
    [aqiBody setMayBlankString:self.area forKey:@"area"];

    [json setObject:aqiBody forKey:@"m"];
    [json setMayBlankString:self.tips forKey:@"d"];
    return json;
}

- (int)aqiLevel {
    if([XXStringUtils isBlank:self.quality]) return -1;
    
    if([@"优" isEqualToString:self.quality] || [@"良" isEqualToString:self.quality]) {
        return 1;
    } else if([@"轻度污染" isEqualToString:self.quality] || [@"中度污染" isEqualToString:self.quality]) {
        return 2;
    } else if([@"重度污染" isEqualToString:self.quality]) {
        return 3;
    }
    return -1;
}

- (NSDateComponents *)dateComponentsForUpdateTime {
    if(self.updateTime == nil) return nil;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:self.updateTime];
    return dateComponents;
}

@end
