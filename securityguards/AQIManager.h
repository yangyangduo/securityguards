//
//  AQIManager.h
//  securityguards
//
//  Created by Zhao yang on 2/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CurrentLocationUpdatedEvent.h"
#import "AQIDetail.h"

@interface AQIManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) AQIDetail *currentAqiInfo;

@property (atomic, assign) BOOL locationIsUpdating;
@property (nonatomic, strong) NSDate *locationLastRefreshDate;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

+ (instancetype)manager;
- (void)mayUpdateAqi;

@end
