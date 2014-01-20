//
//  TipsLabel.m
//  securityguards
//
//  Created by hadoop user account on 15/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TipsLabel.h"
#import "UIColor+MoreColor.h"

@implementation TipsLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)labelWithPoint:(CGPoint)point {
    TipsLabel *label = [[[self class] alloc] initWithFrame:CGRectMake(point.x, point.y ,5, 25)];
    label.text = @"|";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textColor = [UIColor appLightBlue];
    return label;
}

@end
