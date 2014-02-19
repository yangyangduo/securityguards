//
//  SensorsDisplayPanel.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorDisplayView.h"

#define SENSOR_DISPLAY_PANEL_HEIGHT 84

@interface SensorsDisplayPanel : UIView

- (instancetype)initWithPoint:(CGPoint)point;

- (void)setNoDataForSensorType:(SensorType)sensorType;
- (void)setValue:(float)value forSensorType:(SensorType)sensorType;

@end
