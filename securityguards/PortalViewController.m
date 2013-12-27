//
//  MainViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalViewController.h"
#import "LoginViewController.h"
#import "XXStringUtils.h"
#import "GlobalSettings.h"

@interface PortalViewController ()

@end

@implementation PortalViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.topbarView.title = @"Test";
    
    BOOL hasLogin = ![[XXStringUtils emptyString] isEqualToString:[GlobalSettings defaultSettings].secretKey];
    if(hasLogin) {
        
    } else {
        [self presentViewController:[[LoginViewController alloc] init] animated:NO completion:^{}];
    }
    
NSString *str =     [[self.parentViewController.parentViewController class] description];
    NSLog(str);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [super initUI];
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 8 - 55 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? (20 + 8) : 8, 55 / 2, 55 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_drawer_right"] forState:UIControlStateNormal];
    [self.topbarView addSubview:btnRight];
}

@end
