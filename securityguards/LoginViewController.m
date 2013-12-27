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

@implementation LoginViewController{
    UITextField *txtPhoneNumber;
    UITextField *txtPassword;
    UIButton *btnLogin;
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
    
    //self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    
    
    UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(230, 150, 80, 29)];
    [btnTest setTitle:@"Skip" forState:UIControlStateNormal];
    [btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTest.backgroundColor = [UIColor blackColor];
    [btnTest addTarget:self action:@selector(btnTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTest];
}
- (void)initUI{
    
    UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImgView.image = [UIImage imageNamed:@"login-image-bg.png"];
    [self.view addSubview:backgroundImgView];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 389/2, 147/2)];
    logoImgView.center = CGPointMake(self.view.center.x, logoImgView.center.y);
    logoImgView.image = [UIImage imageNamed:@"logo-login.png"];
    [self.view addSubview:logoImgView];
    
    if (txtPhoneNumber == nil) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, logoImgView.frame.origin.y+logoImgView.frame.size.height+40, 400/2, 53/2)];
        txtPhoneNumber.center = CGPointMake(self.view.center.x, txtPhoneNumber.center.y);
        [txtPhoneNumber setBackground:[UIImage imageNamed:@"textbox-white-400.png"]];
        txtPhoneNumber.placeholder = @"手机号";
        [self.view addSubview:txtPhoneNumber];
    }
    
    if (txtPassword == nil) {
        txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, txtPhoneNumber.frame.origin.y+txtPhoneNumber.frame.size.height+20, 400/2, 53/2)];
        txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
        [txtPassword setBackground:[UIImage imageNamed:@"textbox-white-400.png"]];
        txtPassword.placeholder = @"密码";
        [self.view addSubview:txtPassword];
    }
    
    if (btnLogin == nil) {
        btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y+txtPassword.frame.size.height+20, 400/2, 53/2)];
        btnLogin.center = CGPointMake(self.view.center.x,btnLogin.center.y);
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"button-royalblue-400.png"] forState:UIControlStateNormal];
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"button-skyblue-400.png"] forState:UIControlStateDisabled];
        [self.view addSubview:btnLogin];
    }
    
    
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
