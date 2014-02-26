//
//  NavigationViewController.m
//  funding
//
//  Created by Zhao yang on 12/18/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController {
    UIButton *btnLeft;
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

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(popupViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnLeft];
}

- (void)setUp {
    [super setUp];
}

- (void)popupViewController {
    if(self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIButton *)leftButton {
    return btnLeft;
}

@end
