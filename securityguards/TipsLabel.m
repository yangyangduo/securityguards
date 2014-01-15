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

+ (UILabel *)labelWithPoint:(CGPoint)point{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(point.x,point.y ,5, 0)];
    return label;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
