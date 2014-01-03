//
//  DirectionButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DirectionButton.h"
#import "DirectionItemButton.h"

@implementation DirectionButton {
    UITapGestureRecognizer *tapGesture;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, (385.f * 0.7) / 2, (385.f * 0.7) / 2)];
    if(self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat scale = 0.7;
    
    CGFloat topDownWidth = 262 * scale;
    CGFloat topDownHeight = 121 * scale;
    CGFloat leftRightWidth = 122 * scale;
    CGFloat leftRightHeight = 261 * scale;

    DirectionItemButton *btnLeft = [[DirectionItemButton alloc] initWithFrame:CGRectMake(0, 0, leftRightWidth / 2, leftRightHeight / 2)];
    btnLeft.center = CGPointMake(btnLeft.center.x, self.bounds.size.height / 2);
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_camera_left"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_camera_left_selected"] forState:UIControlStateHighlighted];
    btnLeft.identifier = @"l";
    [btnLeft addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnLeft];
    
    DirectionItemButton *btnRight = [[DirectionItemButton alloc] initWithFrame:CGRectMake((self.bounds.size.width- leftRightWidth / 2) , 0, leftRightWidth / 2, leftRightHeight / 2)];
    btnRight.center = CGPointMake(btnRight.center.x, self.bounds.size.height / 2);
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_camera_right"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_camera_right_selected"] forState:UIControlStateHighlighted];
    btnRight.identifier = @"r";
    [btnRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnRight];
    
    DirectionItemButton *btnTop = [[DirectionItemButton alloc] initWithFrame:CGRectMake(0, 0, topDownWidth / 2, topDownHeight / 2)];
    btnTop.center = CGPointMake(self.bounds.size.width / 2, btnTop.center.y);
    [btnTop setBackgroundImage:[UIImage imageNamed:@"btn_camera_top"] forState:UIControlStateNormal];
    [btnTop setBackgroundImage:[UIImage imageNamed:@"btn_camera_top_selected"] forState:UIControlStateHighlighted];
    btnTop.identifier = @"u";
    [btnTop addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTop];

    DirectionItemButton *btnBottom = [[DirectionItemButton alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height - topDownHeight / 2), topDownWidth / 2, topDownHeight / 2)];
    btnBottom.center = CGPointMake(self.bounds.size.width / 2, btnBottom.center.y);
    [btnBottom setBackgroundImage:[UIImage imageNamed:@"btn_camera_bottom"] forState:UIControlStateNormal];
    [btnBottom setBackgroundImage:[UIImage imageNamed:@"btn_camera_bottom_selected"] forState:UIControlStateHighlighted];
    btnBottom.identifier = @"d";
    [btnBottom addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBottom];
    
//    if(tapGesture == nil) {
//        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//        [self addGestureRecognizer:tapGesture];
//    }
}

- (void)btnClicked:(XXButton *)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(directionButtonClicked:)]) {
        Direction dir = DirectionUpNone;
        if([@"u" isEqualToString:sender.identifier]) {
            dir = DirectionUp;
        } else if([@"d" isEqualToString:sender.identifier]) {
            dir = DirectionDown;
        } else if([@"l" isEqualToString:sender.identifier]) {
            dir = DirectionLeft;
        } else if([@"r" isEqualToString:sender.identifier]) {
            dir = DirectionRight;
        }
        [self.delegate directionButtonClicked:dir];
    }
}

@end
