//
//  AQIPanelView.m
//  securityguards
//
//  Created by Zhao yang on 2/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AQIPanelView.h"
#import "UIColor+MoreColor.h"

@implementation AQIPanelView {
    UILabel *lblCityTitle;
    UILabel *lblAQI;
    UILabel *lblAQIDescriptions;
    UILabel *lblTips;
    
    UIImageView *imgAqiLevel;
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

    UIView *aqiBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, AQI_PANEL_VIEW_HEIGHT)];
    aqiBackgroundView.backgroundColor = [UIColor appDarkDarkGray];
    [self addSubview:aqiBackgroundView];

    imgAqiLevel = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100 / 2, 10 / 2)];
    imgAqiLevel.image = [UIImage imageNamed:@"line_aqi_fine"];
    [self addSubview:imgAqiLevel];

    lblAQI = [[UILabel alloc] initWithFrame:CGRectMake(5, imgAqiLevel.frame.origin.y + imgAqiLevel.bounds.size.height + 2, 64, 27)];
    lblAQI.textColor = [UIColor whiteColor];
    lblAQI.font = [UIFont systemFontOfSize:24.f];
    lblAQI.textAlignment = NSTextAlignmentCenter;
    lblAQI.backgroundColor = [UIColor clearColor];
    lblAQI.text = @" -- ";
    [self addSubview:lblAQI];

    lblAQIDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(5, lblAQI.frame.origin.y + lblAQI.bounds.size.height, 64, 22)];
    lblAQIDescriptions.textColor = [UIColor whiteColor];
    lblAQIDescriptions.font = [UIFont systemFontOfSize:16.f];
    lblAQIDescriptions.textAlignment = NSTextAlignmentCenter;
    lblAQIDescriptions.backgroundColor = [UIColor clearColor];
    lblAQIDescriptions.text = @" ---- ";
    [self addSubview:lblAQIDescriptions];

    UIImageView *lineDividing = [[UIImageView alloc] initWithFrame:CGRectMake(75, 5, 2, AQI_PANEL_VIEW_HEIGHT - 10)];
    lineDividing.image = [UIImage imageNamed:@"line_aqi_gray"];
    [self addSubview:lineDividing];

    lblCityTitle = [[UILabel alloc] initWithFrame:CGRectMake(83, 5, 200, 25)];
    lblCityTitle.backgroundColor = [UIColor clearColor];
    lblCityTitle.font = [UIFont systemFontOfSize:18.f];
    
    lblTips = [[UILabel alloc] initWithFrame:CGRectMake(83, 30, 235, 35)];
    lblTips.font = [UIFont systemFontOfSize:14.f];
    lblTips.numberOfLines = 2;
    lblTips.textColor = [UIColor lightGrayColor];
    lblTips.backgroundColor = [UIColor clearColor];

    [self addSubview:lblCityTitle];
    [self addSubview:lblTips];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, AQI_PANEL_VIEW_HEIGHT - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    line.image = [UIImage imageNamed:@"line_dashed_white"];
    [self addSubview:line];
}

- (void)setCity:(NSString *)city dateComponets:(NSDateComponents *)dateComponents aqiNumber:(int)aqiNumber aqiText:(NSString *)aqiText tips:(NSString *)tips level:(int)level {

    if(imgAqiLevel != nil) {
        if(level == 2) {
           imgAqiLevel.image = [UIImage imageNamed:@"line_aqi_fine"];
        } else if(level == 3) {
            imgAqiLevel.image = [UIImage imageNamed:@"line_aqi_warning"];
        } else {
            imgAqiLevel.image = [UIImage imageNamed:@"line_aqi_great"];
        }
    }
    
    if(lblCityTitle != nil) {
        if([XXStringUtils isBlank:city]) {
            lblCityTitle.text = [XXStringUtils emptyString];
        } else {
            /*
                 update time == NULL         =====>  ----
                 update time == today        =====>  今日空气质量
                 update time == today - 1    =====>  昨日空气质量
                 else                        =====>  XX日空气质量
             */
            NSString *_day_ = [XXStringUtils emptyString];
            if(dateComponents != nil) {
                NSDate *today = [NSDate date];
                NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:today];
                if(todayComponents.month == dateComponents.month) {
                    if(todayComponents.day == dateComponents.day) {
                        _day_ = NSLocalizedString(@"today", @"");
                    } else if(todayComponents.day == dateComponents.day - 1) {
                        _day_ = NSLocalizedString(@"yesterday", @"");
                    } else {
                        int d = dateComponents.day;
                        if(d <= 9 && d >= 1) {
                            _day_ = [NSString stringWithFormat:@"0%d", d];
                        } else {
                            _day_ = [NSString stringWithFormat:@"%d", d];
                        }
                    }
                } else {
                    _day_ = @" -- ";
                }
            }
            lblCityTitle.text = [NSString stringWithFormat:@"%@%@%@", city, _day_, NSLocalizedString(@"aqi_today", @"")];
        }
    }
    
    if(lblAQI != nil) {
        lblAQI.text = [NSString stringWithFormat:@"%d", aqiNumber];
    }

    if(lblAQIDescriptions != nil) {
        if([XXStringUtils isBlank:aqiText]) {
            lblAQIDescriptions.text = @" ---- ";
        } else {
            lblAQIDescriptions.text = aqiText;
        }
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
