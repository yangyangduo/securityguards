//
//  ToPortalViewController.m
//  securityguards
//
//  Created by Zhao yang on 4/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ToPortalViewController.h"
#import "Shared.h"

@interface ToPortalViewController ()

@end

@implementation ToPortalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    [super initUI];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"icon_portal_view"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnRightPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRight];
}

- (void)btnRightPressed:(id)sender {
    [self toPortalView];
}

- (void)toPortalView {
    if(self.navigationController != nil) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[Shared shared].app.rootViewController showCenterView:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
