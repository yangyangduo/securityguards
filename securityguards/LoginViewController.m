//
//  LoginViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    
    UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(230, 450, 80, 29)];
    [btnTest setTitle:@"Skip" forState:UIControlStateNormal];
    [btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTest.backgroundColor = [UIColor blackColor];
    [btnTest addTarget:self action:@selector(btnTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTest];
}

- (void)btnTestPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
