//
//  CameraView.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraView.h"
#import "UIColor+MoreColor.h"

@implementation CameraView {
    UIImageView *imgCamera;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 250)];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appDarkGray];
    
    imgCamera = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 240)];
    imgCamera.backgroundColor = [UIColor colorWithRed:102.f / 255.f green:102.f / 255.f blue:102.f / 255.f alpha:1.0f];
    [self addSubview:imgCamera];
}

@end
