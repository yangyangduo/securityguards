//
//  SensorDisplayView.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Sensor.h"

#define NO_VALUE @"------"

typedef NS_ENUM(NSUInteger, SensorDisplayViewState) {
    SensorDisplayViewStateNormal,
    SensorDisplayViewStateWarning,
    SensorDisplayViewStateAlarm
};

@interface SensorDisplayView : UIView

@property (nonatomic) SensorDisplayViewState sensorDisplayViewState;
@property (nonatomic) SensorType sensorType;

- (instancetype)initWithPoint:(CGPoint)point sensorType:(SensorType)sensorType;

- (void)setDisplayValue:(NSString *)displayValue;

@end
