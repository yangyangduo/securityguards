//
//  BlueButton.m
//  securityguards
//
//  Created by Zhao yang on 1/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BlueButton.h"
#import "UIImage+ImageHandler.h"

@implementation BlueButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (BlueButton *)blueButtonWithPoint:(CGPoint)aPoint resize:(CGSize)aSize {
    BlueButton *button = [[BlueButton alloc] initWithFrame:CGRectMake(aPoint.x, aPoint.y, aSize.width, aSize.height)];
    UIImage *imgNormal = [UIImage reSizeImage:[UIImage imageNamed:@"btn_blue.png"] toSize:aSize];
    UIImage *imgDisable = [UIImage reSizeImage:[UIImage imageNamed:@"btn_gray.png"] toSize:aSize];
    UIImage *imgHighligted = [UIImage reSizeImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] toSize:aSize];
    [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imgDisable forState:UIControlStateDisabled];
    [button setBackgroundImage:imgHighligted forState:UIControlStateHighlighted];
    return button;
}

@end
