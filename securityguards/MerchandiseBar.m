//
//  MerchandiseBar.m
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseBar.h"
#import "UIColor+MoreColor.h"
#import "XXStringUtils.h"

@implementation MerchandiseBar {
    UILabel *lblPrice;
    UILabel *lblDescriptions;
}

@synthesize price = _price_;
@synthesize merchandiseDescriptions = _merchandiseDescriptions_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor appDarkGray];
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(141, 7, 70, 30)];
        lblDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(215, 18, 95, 20)];
        
        lblPrice.textColor = [UIColor orangeColor];
        lblPrice.font = [UIFont boldSystemFontOfSize:18.f];
        
        lblDescriptions.textColor = [UIColor whiteColor];
        lblDescriptions.font = [UIFont systemFontOfSize:11.f];
        lblDescriptions.textAlignment = NSTextAlignmentCenter;
        
        lblPrice.backgroundColor = [UIColor clearColor];
        lblDescriptions.backgroundColor = [UIColor clearColor];
        
        [self addSubview:lblPrice];
        [self addSubview:lblDescriptions];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    if((self = [self initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 44)])) {
    }
    return self;
}

- (void)setMerchandiseBarState:(MerchandiseBarState)state merchandisePrice:(float)merchandisePrice merchandiseDescriptions:(NSString *)merchandiseDescriptions {
    
    _price_ = merchandisePrice;
    _merchandiseDescriptions_ = merchandiseDescriptions;
    
    lblPrice.text = [NSString stringWithFormat:@"￥%d", (int)merchandisePrice];
    lblDescriptions.text = [XXStringUtils isBlank:self.merchandiseDescriptions] ? [XXStringUtils emptyString] :self.merchandiseDescriptions;
    
    if(state == MerchandiseBarStateNormal) {
        self.backgroundColor = [UIColor appDarkGray];
        lblPrice.textColor = [UIColor orangeColor];
        lblDescriptions.hidden = YES;
    } else if(state == MerchandiseBarStateHighlighted) {
        self.backgroundColor = [UIColor orangeColor];
        lblPrice.textColor = [UIColor whiteColor];
        lblDescriptions.hidden = NO;
    }
}

@end
