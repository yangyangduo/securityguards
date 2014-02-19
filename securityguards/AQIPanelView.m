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
}

- (void)setCity:(NSString *)city aqiNumber:(int)aqiNumber tips:(NSString *)tips {
    if(lblCityTitle != nil) {
        if([XXStringUtils isBlank:city]) {
            lblCityTitle.text = [XXStringUtils emptyString];
        } else {
            
        }
    }
    
    if(lblAQI != nil) {
        
    }
    
    if(lblTips != nil) {
        if([XXStringUtils isBlank:tips]) {
            lblTips.text = [XXStringUtils emptyString];
        } else {
            
        }
    }
}

@end
