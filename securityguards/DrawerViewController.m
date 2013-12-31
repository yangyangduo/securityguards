//
//  DrawerViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DrawerViewController.h"
#import "XXDrawerViewController.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(8, [UIDevice systemVersionIsMoreThanOrEuqal7] ? (20 + 8) : 8, 55 / 2, 55 / 2)];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_drawer_left"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(showLeftDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnLeft];
}

- (void)showLeftDrawerView:(id)sender {
    if(self.parentViewController != nil && self.parentViewController.parentViewController != nil) {
        if([self.parentViewController.parentViewController isKindOfClass:[XXDrawerViewController class]]) {
            XXDrawerViewController *drawerController = (XXDrawerViewController *)self.parentViewController.parentViewController;
            [drawerController showLeftView];
        }
    }
}

@end
