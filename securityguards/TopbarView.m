//
//  TopbarView.m
//  funding
//
//  Created by Zhao yang on 12/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TopbarView.h"

@implementation TopbarView {
    UILabel *lblTitle;
}

@synthesize title = _title_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgBackground.image = [UIImage imageNamed:@"bg_topbar"];
        [self addSubview:imgBackground];
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 220, 44)];
        lblTitle.center = CGPointMake(self.center.x, lblTitle.center.y);
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:lblTitle];
    }
    return self;
}

+ (TopbarView *)topbar {
    TopbarView *topbar = [[TopbarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 64 : 44)];
    return topbar;
}

- (void)setTitle:(NSString *)title {
    _title_ = title;
    if(lblTitle != nil && lblTitle.superview != nil) {
        if(_title_ != nil) {
            lblTitle.text = _title_;
        } else {
            lblTitle.text = @"";
        }
    }
}

@end
