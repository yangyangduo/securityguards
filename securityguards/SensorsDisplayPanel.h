//
//  SensorsDisplayPanel.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorDisplayView.h"

@interface SensorsDisplayPanel : UIView

- (instancetype)initWithPoint:(CGPoint)point;

- (void)setValue:(NSString *)value forSensorType:(SensorDisplayViewType)sensorType;

@end
