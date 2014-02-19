//
//  SensorDisplayView.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SensorDisplayView.h"
#import "UIColor+MoreColor.h"

@implementation SensorDisplayView {
    UIImageView *imageView;
    UILabel *lblValue;
    UIImageView *imgDescBackground;
    UILabel *lblDescription;
    
    NSString *basicImageName;
}

@synthesize sensorDisplayViewState = _sensorDisplayViewState_;
@synthesize sensorType = _sensorType_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point sensorType:(SensorType)sensorType {
    self = [super initWithFrame:CGRectMake(point.x, point.y, 150, SENSOR_DISPLAY_VIEW_HEIGHT)];
    if(self){
        _sensorType_ = sensorType;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54 / 2, 54 / 2)];
    
    lblValue = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 65, 29)];
    lblValue.textAlignment = NSTextAlignmentCenter;
    lblValue.font = [UIFont systemFontOfSize:15.f];
    lblValue.backgroundColor = [UIColor clearColor];
    
    imgDescBackground = [[UIImageView alloc] initWithFrame:CGRectMake(100, 4.f, 100 / 2, 40 / 2)];
    lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 56, 20)];
    lblDescription.textColor = [UIColor whiteColor];
    lblDescription.font = [UIFont systemFontOfSize:12.f];
    lblDescription.backgroundColor = [UIColor clearColor];
    [imgDescBackground addSubview:lblDescription];
    
    [self addSubview:imageView];
    [self addSubview:lblValue];
    [self addSubview:imgDescBackground];
    
    imageView.image = [UIImage imageNamed:@"icon_temp_blue"];
    lblValue.text = NO_VALUE;
    
    self.sensorType = _sensorType_;
    self.sensorDisplayViewState = SensorDisplayViewStateNormal;
}

- (void)setSensorType:(SensorType)sensorType {
    _sensorType_ = sensorType;
    if(SensorTypeTempure == _sensorType_) {
        lblDescription.text = NSLocalizedString(@"tempure", @"");
        basicImageName = @"icon_temp";
    } else if(SensorTypeHumidity == _sensorType_) {
        lblDescription.text = NSLocalizedString(@"humidity", @"");
        basicImageName = @"icon_humidity";
    } else if(SensorTypePM25 == _sensorType_) {
        lblDescription.text = NSLocalizedString(@"pm25", @"");
        basicImageName = @"icon_pm25";
    } else if(SensorTypeVOC == _sensorType_) {
        lblDescription.text = NSLocalizedString(@"voc", @"");
        basicImageName = @"icon_voc";
    }
}

- (void)setSensorDisplayViewState:(SensorDisplayViewState)sensorDisplayViewState {
    _sensorDisplayViewState_ = sensorDisplayViewState;
    NSString *stateImageExtension = @"blue";
    if(SensorDisplayViewStateNormal == _sensorDisplayViewState_) {
        imgDescBackground.image = [UIImage imageNamed:@"bg_label_gray"];
        lblValue.textColor = [UIColor appBlue];
    } else if(SensorDisplayViewStateAlarm == _sensorDisplayViewState_) {
        stateImageExtension = @"red";
        imgDescBackground.image = [UIImage imageNamed:@"bg_label_red"];
        lblValue.textColor = [UIColor appRed];
    } else if(SensorDisplayViewStateWarning == _sensorDisplayViewState_) {
        stateImageExtension = @"yellow";
        imgDescBackground.image = [UIImage imageNamed:@"bg_label_yellow"];
        lblValue.textColor = [UIColor appDarkYellow];
    }
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", basicImageName, stateImageExtension]];
}

- (void)setDisplayValue:(NSString *)displayValue {
    lblValue.text = [XXStringUtils isBlank:displayValue] ? NO_VALUE : displayValue;
}

@end
