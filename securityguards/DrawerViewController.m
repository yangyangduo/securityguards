//
//  DrawerViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DrawerViewController.h"
#import "XXDrawerViewController.h"
#import "Shared.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController {
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [super initUI];
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_nav"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(showLeftDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnLeft];
}

- (void)showLeftDrawerView:(id)sender {
    [[Shared shared].app.rootViewController showLeftView];
}

@end
