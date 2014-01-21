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
    
    tempureSensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(5, 10) sensorType:SensorDisplayViewTypeTempure];
    humiditySensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(165, 10) sensorType:SensorDisplayViewTypeHumidity];
    pm25Sensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(5, 47) sensorType:SensorDisplayViewTypePM25];
    vocSensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(165, 47) sensorType:SensorDisplayViewTypeVOC];
    
    [self addSubview:tempureSensor];
    [self addSubview:humiditySensor];
    [self addSubview:pm25Sensor];
    [self addSubview:vocSensor];   
}

- (void)setValue:(NSString *)value forSensorType:(SensorDisplayViewType)sensorType {
    if(SensorDisplayViewTypeTempure == sensorType) {
        [tempureSensor setDisplayValue:value];
        tempureSensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorDisplayViewTypeHumidity == sensorType) {
        [humiditySensor setDisplayValue:value];
        humiditySensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorDisplayViewTypePM25 == sensorType) {
        [pm25Sensor setDisplayValue:[self pm25OrVocStateStringAsReadableString:value]];
        pm25Sensor.sensorDisplayViewState = SensorDisplayViewStateWarning;
    } else if(SensorDisplayViewTypeVOC == sensorType) {
        [vocSensor setDisplayValue:[self pm25OrVocStateStringAsReadableString:value]];
        vocSensor.sensorDisplayViewState = SensorDisplayViewStateAlarm;
    }
}

- (NSString *)pm25OrVocStateStringAsReadableString:(NSString *)stateString {
    int state = [stateString intValue];
    switch (state) {
        case 1:
            return NSLocalizedString(@"sensor_great", @"");
        case 2:
            return NSLocalizedString(@"sensor_fine", @"");
        case 3:
            return NSLocalizedString(@"sensor_light_pollution", @"");
        case 4:
            return NSLocalizedString(@"sensor_moderate_pollution", @"");
        case 5:
            return NSLocalizedString(@"sensor_severe_pollution", @"");
        case 6:
            return NSLocalizedString(@"sensor_very_severe_pollution", @"");
        default:
            return [XXStringUtils emptyString];
    }
}

@end
