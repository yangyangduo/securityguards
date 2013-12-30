//
//  LoginViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterStep1ViewController.h"
#import "AccountService.h"
#import "JsonUtils.h"
#import "DeviceCommand.h"
#import "XXStringUtils.h"
#import "CoreService.h"
#import "AlertView.h"
#import "ForgetPasswordViewController.h"
#define ORIGIN_HEIGHT [UIScreen mainScreen].bounds.size.height/6

@interface LoginViewController ()
@end

@implementation LoginViewController{
    UITextField *txtPhoneNumber;
    UITextField *txtPassword;
    UIButton *btnLogin;
    UIButton *btnForgetPassword;
    UIButton *btnRegister;
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
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ORIGIN_HEIGHT, 389/2, 147/2)];
    logoImgView.center = CGPointMake(self.view.center.x, logoImgView.center.y);
    logoImgView.image = [UIImage imageNamed:@"logo-login.png"];
    [self.view addSubview:logoImgView];
    
    if (txtPhoneNumber == nil) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(0, logoImgView.frame.origin.y+logoImgView.frame.size.height+40, 400/2, 53/2)];
        txtPhoneNumber.center = CGPointMake(self.view.center.x, txtPhoneNumber.center.y);
        [txtPhoneNumber setBackground:[UIImage imageNamed:@"textbox-white-400.png"]];
        txtPhoneNumber.placeholder = NSLocalizedString(@"phone.number", @"");
        txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPassword.autocorrectionType = UITextAutocapitalizationTypeNone;
        txtPhoneNumber.font = [UIFont systemFontOfSize:14.f];
        txtPhoneNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,6, 0)];
        txtPhoneNumber.leftViewMode  = UITextFieldViewModeAlways;
        txtPhoneNumber.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:txtPhoneNumber];
    }
    
    if (txtPassword == nil) {
        txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, txtPhoneNumber.frame.origin.y+txtPhoneNumber.frame.size.height+20, 400/2, 53/2)];
        txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
        [txtPassword setBackground:[UIImage imageNamed:@"textbox-white-400.png"]];
        txtPassword.placeholder = NSLocalizedString(@"password", @"");
        txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPassword.autocorrectionType = UITextAutocapitalizationTypeNone;
        txtPassword.secureTextEntry = YES;
        [self.view addSubview:txtPassword];
    }
    
    if (btnLogin == nil) {
        btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y+txtPassword.frame.size.height+20, 400/2, 53/2)];
        btnLogin.center = CGPointMake(self.view.center.x,btnLogin.center.y);
        [btnLogin setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"button-royalblue-400.png"] forState:UIControlStateNormal];
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"button-skyblue-400.png"] forState:UIControlStateHighlighted];
        [btnLogin setImage:[UIImage imageNamed:@"button-gray-400.png"] forState:UIControlStateDisabled];
        [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLogin addTarget:self action:@selector(btnLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogin];
    }
    
    UILabel *lblSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, 5, 44)];
    lblSeperator.text = @"|";
    lblSeperator.font = [UIFont systemFontOfSize:16.0f];
    lblSeperator.center = CGPointMake(self.view.center.x, lblSeperator.center.y);
    [self.view addSubview:lblSeperator];
    
    if (btnForgetPassword == nil) {
        btnForgetPassword = [[UIButton alloc] initWithFrame:CGRectMake(lblSeperator.frame.origin.x-80, self.view.frame.size.height-64, 80, 44)];
        [btnForgetPassword setTitle:NSLocalizedString(@"forget.password", @"") forState:UIControlStateNormal];
        btnForgetPassword.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btnForgetPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnForgetPassword addTarget:self action:@selector(btnForgetPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnForgetPassword];
    }
    if (btnRegister == nil) {
        btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(lblSeperator.frame.origin.x+5, btnForgetPassword.frame.origin.y,80, 44)];
        [btnRegister setTitle:NSLocalizedString(@"register.account", @"") forState:UIControlStateNormal];
        btnRegister.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btnRegister setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnRegister addTarget:self action:@selector(btnRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRegister];
        
    }
    
    
}

#pragma mark-
#pragma mark button action

- (void)btnLoginPressed:(id)sender {
    AccountService *accountService = [[AccountService alloc] init];

    [accountService loginWithAccount:txtPhoneNumber.text password:txtPassword.text success:@selector(loginSuccess:) failed:@selector(loginFailed:) target:self callback:nil];
}

- (void)loginSuccess:(RestResponse *) resp{
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            DeviceCommand *command = [[DeviceCommand alloc] initWithDictionary:json];
            if(command != nil && ![XXStringUtils isBlank:command.result]) {
                if([@"1" isEqualToString:command.result]) {
                    // login success
                    if(![XXStringUtils isBlank:command.security] && ![XXStringUtils isBlank:command.tcpAddress]) {
                        // save account info
                        GlobalSettings *settings = [GlobalSettings defaultSettings];
                        settings.account = txtPhoneNumber.text;
                        settings.secretKey = command.security;
                        settings.tcpAddress = command.tcpAddress;
                        settings.deviceCode = command.deviceCode;
                        settings.restAddress = command.restAddress;
                        [settings saveSettings];
                        
                        // start service
                        [[CoreService defaultService] startService];
                        
                        txtPassword.text = [XXStringUtils emptyString];
                        [self toMainPage];
                        return;
                    }
                } else if([@"-1" isEqualToString:command.result] || [@"-2" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"name_or_pwd_error", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:command.result] || [@"-4" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"login_later", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self loginFailed:resp];
    
}
- (void)loginFailed:(RestResponse *) resp{
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)btnForgetPasswordPressed:(id)sender {
    ForgetPasswordViewController *forgetPasswordViewController = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}

- (void)btnRegisterPressed:(id)sender {
    RegisterStep1ViewController *registerStep1ViewController = [[RegisterStep1ViewController alloc] init];
    [self.navigationController pushViewController:registerStep1ViewController animated:YES];
}


- (void)btnTestPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) toMainPage{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
