//
//  SensorsDisplayPanel.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorDisplayView.h"

// 4 is count of sensor display view
#define SENSOR_DISPLAY_PANEL_HEIGHT SENSOR_DISPLAY_VIEW_HEIGHT * 4 + 10 * 4 + 10

@interface SensorsDisplayPanel : UIView

- (instancetype)initWithPoint:(CGPoint)point;

- (void)setNoDataForSensorType:(SensorType)sensorType;
- (void)setValue:(float)value forSensorType:(SensorType)sensorType;

@end
