//
//  SensorDisplayView.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

typedef NS_ENUM(NSUInteger, SensorDisplayViewColor) {
    SensorDisplayViewColorBlue,
    SensorDisplayViewColorYellow,
    SensorDisplayViewColorRed
};

@interface SensorDisplayView : UIView

@property (nonatomic, assign) SensorDisplayViewColor sensorDisplayViewColor;
@property (nonatomic, strong) Device *device;

- (id)initWithPoint:(CGPoint)point andDevice:(Device *)device;

@end
