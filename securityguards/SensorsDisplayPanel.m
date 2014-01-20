//
//  SensorsDisplayPanel.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SensorsDisplayPanel.h"
#import "UIColor+MoreColor.h"

@implementation SensorsDisplayPanel {
    SensorDisplayView *tempureSensor;
    SensorDisplayView *humiditySensor;
    SensorDisplayView *pm25Sensor;
    SensorDisplayView *vocSensor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 84)];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appGray];
    
    tempureSensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 10) sensorType:SensorDisplayViewTypeTempure];
    humiditySensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 10) sensorType:SensorDisplayViewTypeHumidity];
    pm25Sensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 47) sensorType:SensorDisplayViewTypePM25];
    vocSensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 47) sensorType:SensorDisplayViewTypeVOC];
    
    [self addSubview:tempureSensor];
    [self addSubview:humiditySensor];
    [self addSubview:pm25Sensor];
    [self addSubview:vocSensor];
}

- (void)setValue:(NSString *)value forSensorType:(SensorDisplayViewType)sensorType {
    if(SensorDisplayViewTypeTempure == sensorType) {
        
    } else if(SensorDisplayViewTypeHumidity == sensorType) {
        
    } else if(SensorDisplayViewTypePM25 == sensorType) {
        
    } else if(SensorDisplayViewTypeVOC == sensorType) {
        
    }
}

@end
