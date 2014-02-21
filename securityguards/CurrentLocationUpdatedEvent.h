//
//  CurrentLocationUpdatedEvent.h
//  securityguards
//
//  Created by Zhao yang on 2/21/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "EventNameContants.h"
#import "AQIDetail.h"

@interface CurrentLocationUpdatedEvent : XXEvent

@property (nonatomic, strong) AQIDetail *aqiDetail;

- (id)initWithAqiDetail:(AQIDetail *)aqiDetail;

@end
