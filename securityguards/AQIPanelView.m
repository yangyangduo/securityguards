//
//  AQIPanelView.m
//  securityguards
//
//  Created by Zhao yang on 2/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AQIPanelView.h"
#import "UIColor+MoreColor.h"
#import "XXStringUtils.h"

@implementation AQIPanelView {
    UILabel *lblCityTitle;
    UILabel *lblAQI;
    UILabel *lblTips;
    
    UIImageView *imgDescBackground;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point {
    self = [self initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, AQI_PANEL_VIEW_HEIGHT)];
    if(self) {
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appGray];
    
    lblCityTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 29)];
    lblCityTitle.font = [UIFont systemFontOfSize:16.f];
    
    imgDescBackground = [[UIImageView alloc] initWithFrame:CGRectMake(145, 9.5f, 300 / 2, 40 / 2)];
    imgDescBackground.image = [[UIImage imageNamed:@"bg_label_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    lblAQI = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 130, 20)];
    lblAQI.textColor = [UIColor whiteColor];
    lblAQI.font = [UIFont systemFontOfSize:12.f];
    lblAQI.textAlignment = NSTextAlignmentCenter;
    lblAQI.backgroundColor = [UIColor clearColor];
    [imgDescBackground addSubview:lblAQI];
    
    lblTips = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 310, 25)];
    lblTips.font = [UIFont systemFontOfSize:14.f];
    lblTips.textColor = [UIColor lightGrayColor];
    
    lblCityTitle.backgroundColor = [UIColor clearColor];
    lblTips.backgroundColor = [UIColor clearColor];
    
    [self addSubview:lblCityTitle];
    [self addSubview:imgDescBackground];
    [self addSubview:lblTips];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, AQI_PANEL_VIEW_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    line.image = [UIImage imageNamed:@"line_dashed_white"];
    [self addSubview:line];
}

- (void)setCity:(NSString *)city aqiNumber:(int)aqiNumber aqiText:(NSString *)aqiText tips:(NSString *)tips level:(int)level {
    if(imgDescBackground != nil) {
        if(level == 2) {
            imgDescBackground.image = [[UIImage imageNamed:@"bg_label_yellow"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        } else if(level == 3) {
            imgDescBackground.image = [[UIImage imageNamed:@"bg_label_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        } else {
            imgDescBackground.image = [[UIImage imageNamed:@"bg_label_gray"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        }
    }
    
    if(lblCityTitle != nil) {
        if([XXStringUtils isBlank:city]) {
            lblCityTitle.text = [XXStringUtils emptyString];
        } else {
            lblCityTitle.text = [NSString stringWithFormat:@"%@%@", city, NSLocalizedString(@"aqi_today", @"")];
        }
    }
    
    if(lblAQI != nil) {
        lblAQI.text = [NSString stringWithFormat:@"%@ %d %@", NSLocalizedString(@"aqi", @""), aqiNumber, aqiText];
    }
    
    if(lblTips != nil) {
        if([XXStringUtils isBlank:tips]) {
            lblTips.text = [XXStringUtils emptyString];
        } else {
            lblTips.text = tips;
        }
    }
}


@end
