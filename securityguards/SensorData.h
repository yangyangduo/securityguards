//
//  SensorData.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"

@interface SensorData : Entity

@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *unitSymbol;
@property (nonatomic) float value;

@end
