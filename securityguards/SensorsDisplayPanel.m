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
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, SENSOR_DISPLAY_PANEL_HEIGHT)];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appGray];
    
    tempureSensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(5, 10) sensorType:SensorTypeTempure];
    humiditySensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(165, 10) sensorType:SensorTypeHumidity];
    pm25Sensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(5, 47) sensorType:SensorTypePM25];
    vocSensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(165, 47) sensorType:SensorTypeVOC];
    
    [self addSubview:tempureSensor];
    [self addSubview:humiditySensor];
    [self addSubview:pm25Sensor];
    [self addSubview:vocSensor];   
}

- (void)setNoDataForSensorType:(SensorType)sensorType {
    if(SensorTypeTempure == sensorType) {
        [tempureSensor setDisplayValue:NO_VALUE];
        tempureSensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorTypeHumidity == sensorType) {
        [humiditySensor setDisplayValue:NO_VALUE];
        humiditySensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorTypePM25 == sensorType) {
        [pm25Sensor setDisplayValue:NO_VALUE];
        pm25Sensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorTypeVOC == sensorType) {
        [vocSensor setDisplayValue:NO_VALUE];
        vocSensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    }
}

- (void)setValue:(float)value forSensorType:(SensorType)sensorType {
    if(SensorTypeTempure == sensorType) {
        [tempureSensor setDisplayValue:[NSString stringWithFormat:@"%.1f(%@)", value, NSLocalizedString(@"tempure_display", @"")]];
        tempureSensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorTypeHumidity == sensorType) {
        NSString *desc = [XXStringUtils emptyString];
        if(value <= 20) {
            desc = NSLocalizedString(@"humidity_low", @"");
        } else if(value > 65) {
            desc = NSLocalizedString(@"humidity_high", @"");
        } else {
            desc = NSLocalizedString(@"humidity_middle", @"");
        }
        [humiditySensor setDisplayValue:[NSString stringWithFormat:@"%.0f%%(%@)", value, desc]];
        humiditySensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
    } else if(SensorTypePM25 == sensorType) {
        [pm25Sensor setDisplayValue:[self pm25OrVocStateStringAsReadableString:value]];
        if(value >= 1 && value <= 2) {
            pm25Sensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
        } else if(value >=3 && value <= 4) {
            pm25Sensor.sensorDisplayViewState = SensorDisplayViewStateWarning;
        } else {
            pm25Sensor.sensorDisplayViewState = SensorDisplayViewStateAlarm;
        }
    } else if(SensorTypeVOC == sensorType) {
        [vocSensor setDisplayValue:[self pm25OrVocStateStringAsReadableString:value]];
        if(value >= 1 && value <= 2) {
            vocSensor.sensorDisplayViewState = SensorDisplayViewStateNormal;
        } else if(value >=3 && value <= 4) {
            vocSensor.sensorDisplayViewState = SensorDisplayViewStateWarning;
        } else {
            vocSensor.sensorDisplayViewState = SensorDisplayViewStateAlarm;
        }
    }
}

- (NSString *)pm25OrVocStateStringAsReadableString:(double)stateValue {
    int state = stateValue;
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
