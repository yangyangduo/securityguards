//
//  SensorDisplayView.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SensorDisplayView.h"
#import "UIColor+MoreColor.h"

#define NO_VALUE @"----"

@implementation SensorDisplayView {
    UIImageView *imageView;
    UILabel *lblValue;
    UIImageView *imgDescBackground;
    UILabel *lblDescription;
    
    NSString *basicImageName;
}

@synthesize sensorDisplayViewState = _sensorDisplayViewState_;
@synthesize sensorDisplayViewType = _sensorDisplayViewType_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point sensorType:(SensorDisplayViewType)sensorType {
    self = [super initWithFrame:CGRectMake(point.x, point.y, 140, 27)];
    if(self){
        _sensorDisplayViewType_ = sensorType;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54 / 2, 54 / 2)];
    
    lblValue = [[UILabel alloc] initWithFrame:CGRectMake(29, 0, 40, 29)];
    lblValue.textAlignment = NSTextAlignmentCenter;
    lblValue.backgroundColor = [UIColor clearColor];
    
    imgDescBackground = [[UIImageView alloc] initWithFrame:CGRectMake(70, 3.5f, 140 / 2, 40 / 2)];
    lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 56, 20)];
    lblDescription.textColor = [UIColor whiteColor];
    lblDescription.font = [UIFont systemFontOfSize:12.f];
    lblDescription.backgroundColor = [UIColor clearColor];
    [imgDescBackground addSubview:lblDescription];
    
    [self addSubview:imageView];
    [self addSubview:lblValue];
    [self addSubview:imgDescBackground];
    
    imageView.image = [UIImage imageNamed:@"icon_temp_blue"];
    lblValue.text = NO_VALUE;
    
    self.sensorDisplayViewType = _sensorDisplayViewType_;
    self.sensorDisplayViewState = SensorDisplayViewStateNormal;
}

- (void)setSensorDisplayViewType:(SensorDisplayViewType)sensorDisplayViewType {
    _sensorDisplayViewType_ = sensorDisplayViewType;
    if(SensorDisplayViewTypeTempure == _sensorDisplayViewType_) {
        lblDescription.text = NSLocalizedString(@"tempure", @"");
        basicImageName = @"icon_temp";
    } else if(SensorDisplayViewTypeHumidity == _sensorDisplayViewType_) {
        lblDescription.text = NSLocalizedString(@"humidity", @"");
        basicImageName = @"icon_humidity";
    } else if(SensorDisplayViewTypePM25 == _sensorDisplayViewType_) {
        lblDescription.text = NSLocalizedString(@"pm25", @"");
        basicImageName = @"icon_pm25";
    } else if(SensorDisplayViewTypeVOC == _sensorDisplayViewType_) {
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

@end
