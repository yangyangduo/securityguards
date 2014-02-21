//
//  CurrentLocationUpdatedEvent.m
//  securityguards
//
//  Created by Zhao yang on 2/21/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CurrentLocationUpdatedEvent.h"

@implementation CurrentLocationUpdatedEvent

@synthesize aqiDetail = _aqiDetail_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventCurrentLocationUpdated;
    }
    return self;
}

- (id)initWithAqiDetail:(AQIDetail *)aqiDetail {
    self = [self init];
    if(self) {
        self.aqiDetail = aqiDetail;
    }
    return self;
}

@end
