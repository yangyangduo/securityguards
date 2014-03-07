//
//  AQIDetail.h
//  securityguards
//
//  Created by Zhao yang on 2/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface AQIDetail : Entity

@property (nonatomic, assign) int aqiNumber;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, strong) NSString *quality;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *tips;

- (int)aqiLevel;
- (NSDateComponents *)dateComponentsForUpdateTime;

@end
