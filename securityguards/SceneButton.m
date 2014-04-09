//
// Created by Zhao yang on 4/8/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "SceneButton.h"
#import "UIColor+MoreColor.h"

@implementation SceneButton {
    BOOL iconIsOnLeft;
}

- (instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)iconImage iconOnleft:(BOOL)iconOnLeft title:(NSString *)title {
    self = [super initWithFrame:frame];
    if(self) {
        iconIsOnLeft = iconOnLeft;
        UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconOnLeft ? 10 : 102, 0, 95.f / 2, 150.f / 2)];
        imgIcon.center = CGPointMake(imgIcon.center.x, self.bounds.size.height / 2.f);
        if(iconImage) {
            imgIcon.image = iconImage;
        }

        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(iconOnLeft ? 55 : 35, 0, 70, 40)];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.center = CGPointMake(lblTitle.center.x, self.bounds.size.height / 2.f);
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.text = title;
        lblTitle.textColor = [UIColor appBlue];
        lblTitle.font = [UIFont systemFontOfSize:20.f];

        [self addSubview:lblTitle];
        [self addSubview:imgIcon];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
//    self.backgroundColor = (highlighted && iconIsOnLeft) ?  [UIColor appWhite] : [UIColor whiteColor];
}

@end