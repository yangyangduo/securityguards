//
//  DirectionItemButton.m
//  securityguards
//
//  Created by Zhao yang on 1/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DirectionItemButton.h"

@implementation DirectionItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [super pointInside:point withEvent:event];
}

@end
