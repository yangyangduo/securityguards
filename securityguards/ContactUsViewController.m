//
//  ContactUsViewController.m
//  securityguards
//
//  Created by hadoop user account on 15/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Shared.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initUI {
    [super initUI];
    
    // remove navigation back button
    for(UIView *view in self.topbarView.subviews) {
        if([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    
    // create show drawer view button instead of back button that we have removed
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_nav"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(showLeftDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnLeft];
}

- (void)showLeftDrawerView:(id)sender {
    [[Shared shared].app.rootViewController showLeftView];
}

@end
