//
//  Sensor.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"
#import "SensorData.h"

typedef enum {
    SensorTypeTempure,
    SensorTypeHumidity,
    SensorTypePM25,
    SensorTypeVOC,
} SensorType;

@interface Sensor : Entity

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *sensorType;
@property (nonatomic, strong) NSString *sensorDataType;
@property (nonatomic, strong) SensorData *data;

@property (nonatomic, readonly) BOOL isTempureSensor;
@property (nonatomic, readonly) BOOL isHumiditySensor;
@property (nonatomic, readonly) BOOL isPM25Sensor;
@property (nonatomic, readonly) BOOL isVOCSensor;

@end
