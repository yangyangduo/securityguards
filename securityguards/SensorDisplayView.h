//
//  SensorDisplayView.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

typedef NS_ENUM(NSUInteger, SensorDisplayViewState) {
    SensorDisplayViewStateNormal,
    SensorDisplayViewStateWarning,
    SensorDisplayViewStateAlarm
};

typedef NS_ENUM(NSUInteger, SensorDisplayViewType) {
    SensorDisplayViewTypeTempure,
    SensorDisplayViewTypeHumidity,
    SensorDisplayViewTypePM25,
    SensorDisplayViewTypeVOC
};

@interface SensorDisplayView : UIView

@property (nonatomic) SensorDisplayViewState sensorDisplayViewState;
@property (nonatomic) SensorDisplayViewType sensorDisplayViewType;

- (instancetype)initWithPoint:(CGPoint)point sensorType:(SensorDisplayViewType)sensorType;

@end
