//
//  SensorsDisplayPanel.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SensorsDisplayPanel.h"
#import "SensorDisplayView.h"
#import "UIColor+MoreColor.h"

@implementation SensorsDisplayPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 84)];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appGray];
    
    SensorDisplayView *sensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 10) andDevice:nil];
    [self addSubview:sensor];
    
    SensorDisplayView *sensor1 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 10) andDevice:nil];
    [self addSubview:sensor1];
    sensor1.sensorDisplayViewState = SensorDisplayViewStateNormal;
    
    SensorDisplayView *sensor2 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 47) andDevice:nil];
    [self addSubview:sensor2];
    sensor2.sensorDisplayViewState = SensorDisplayViewStateWarning;
    
    SensorDisplayView *sensor3 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 47) andDevice:nil];
    [self addSubview:sensor3];
}

@end
