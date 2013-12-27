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
}

@synthesize device = _device_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point andDevice:(Device *)device {
    self = [super initWithFrame:CGRectMake(point.x, point.y, 140, 27)];
    if(self){
        _device_ = device;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54 / 2, 54 / 2)];
    
    lblValue = [[UILabel alloc] initWithFrame:CGRectMake(29, 0, 40, 29)];
    lblValue.textColor = [UIColor appBlue];
    lblValue.textAlignment = NSTextAlignmentCenter;
    lblValue.backgroundColor = [UIColor clearColor];
    
    imgDescBackground = [[UIImageView alloc] initWithFrame:CGRectMake(70, 3.5f, 140 / 2, 40 / 2)];
    imgDescBackground.image = [UIImage imageNamed:@"bg_label_gray"];
    
    lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 56, 20)];
    lblDescription.textColor = [UIColor whiteColor];
    lblDescription.font = [UIFont systemFontOfSize:12.f];
    lblDescription.backgroundColor = [UIColor clearColor];
    
    [imgDescBackground addSubview:lblDescription];
    
    [self addSubview:imageView];
    [self addSubview:lblValue];
    [self addSubview:imgDescBackground];
    
    imageView.image = [UIImage imageNamed:@"icon_temp_blue"];
    lblValue.text = @"28度";
    lblDescription.text = @"细微粉尘";
}

@end
