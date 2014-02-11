//
//  ShoppingStateView.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingStateView.h"
#import "UIColor+MoreColor.h"

@implementation ShoppingStateView {
    UIView *step1View;
    UIView *step2View;
    UIView *step3View;
    
    UIView *progressView;
}

@synthesize state = _state_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        step1View = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 90, 53)];
        step1View.tag = 1;
        step2View = [[UIView alloc] initWithFrame:CGRectMake(115, 0, 90, 53)];
        step2View.tag = 2;
        step3View = [[UIView alloc] initWithFrame:CGRectMake(220, 0, 90, 53)];
        step3View.tag = 3;
        
        [self addSubview:step1View];
        [self addSubview:step2View];
        [self addSubview:step3View];
        
        UIView *backgrondBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 53, self.bounds.size.width, 10)];
        backgrondBarView.backgroundColor = [UIColor appDarkDarkGray];
        [self addSubview:backgrondBarView];
        
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 53, 100, 10)];
        progressView.backgroundColor = [UIColor appBlue];
        [self addSubview:progressView];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point shoppingState:(ShoppingState)shoppingState {
    if( (self = [self initWithFrame:CGRectMake(
        point.x, point.y, [UIScreen mainScreen].bounds.size.width, 63)]) ) {
        self.state = shoppingState;
        [self fillView:step1View withTitle:NSLocalizedString(@"shopping_step1_title", @"") subTitle:NSLocalizedString(@"shopping_step1", @"")];
        [self fillView:step2View withTitle:NSLocalizedString(@"shopping_step2_title", @"") subTitle:NSLocalizedString(@"shopping_step2", @"")];
        [self fillView:step3View withTitle:NSLocalizedString(@"shopping_step3_title", @"") subTitle:NSLocalizedString(@"shopping_step3", @"")];
    }
    return self;
}

- (void)fillView:(UIView *)view withTitle:(NSString *)title subTitle:(NSString *)subTitle {
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 90, 28)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 90, 20)];
    
    label1.tag = 888;
    
    label1.font = [UIFont systemFontOfSize:18.f];
    label2.font = [UIFont systemFontOfSize:14.f];
    
    label1.backgroundColor = [UIColor clearColor];
    label2.backgroundColor = [UIColor clearColor];
    
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    
    label2.textColor = [UIColor lightGrayColor];
    
    label1.text = title;
    label2.text = subTitle;
    
    if(view.tag == self.state) {
        label1.textColor = [UIColor darkGrayColor];
    } else {
        label1.textColor = [UIColor lightGrayColor];
    }
    
    [view addSubview:label1];
    [view addSubview:label2];
}

- (void)setState:(ShoppingState)state {
    _state_ = state;
    CGRect rect = progressView.frame;
    CGFloat entryWidth = 320.f / 3;
    if(_state_ == ShoppingStateSelecting) {
        progressView.frame = CGRectMake(0, rect.origin.y, entryWidth, rect.size.height);
    } else if(_state_ == ShoppingStateConfirmOrder) {
        progressView.frame = CGRectMake(entryWidth, rect.origin.y, entryWidth, rect.size.height);
    } else {
        progressView.frame = CGRectMake(self.bounds.size.width - entryWidth, rect.origin.y, entryWidth, rect.size.height);
    }
}

@end
