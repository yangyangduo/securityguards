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

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        NSDictionary *_m_ = [json dictionaryForKey:@"m"];
        if(_m_ != nil) {
            self.aqiNumber = [_m_ intForKey:@"aqi"];
            self.quality = [_m_ noNilStringForKey:@"quality"];
            self.area = [_m_ noNilStringForKey:@"area"];
        } else {
            self.aqiNumber = 0;
            self.quality = [XXStringUtils emptyString];
            self.area = [XXStringUtils emptyString];
        }
        self.tips = [json noNilStringForKey:@"d"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setObject:@{
                      @"aqi"     : [NSNumber numberWithInt:self.aqiNumber],
                      @"quality" : self.quality == nil ? @"" : self.quality,
                      @"area"    : self.area == nil ? @"" : self.area
                    } forKey:@"m"];
    [json setMayBlankString:self.tips forKey:@"d"];
    return json;
}

@end
