//
//  TimerTaskPlan.m
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimerTaskPlan.h"

@implementation TimerTaskPlan

@synthesize name;
@synthesize scheduleDate;
@synthesize scheduleTime;
@synthesize scheduleMode;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    return json;
}

@end