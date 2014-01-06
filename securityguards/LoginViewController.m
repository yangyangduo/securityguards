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
#import "DeviceCommand.h"
#import "ForgetPasswordViewController.h"
#import "XXTextField.h"
#import "UIDevice+SystemVersion.h"

#define ORIGIN_HEIGHT 52+([UIDevice systemVersionIsMoreThanOrEuqal7]?20:0)

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UITextField *txtPhoneNumber;
    UITextField *txtPassword;
    UIButton *btnLogin;
    UIButton *btnForgetPassword;
    UIButton *btnRegister;
}
@synthesize hasLogin;

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

- (void)initUI{
    [super initUI];
    
    [self registerTapGestureToResignKeyboard];
    UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImgView.image = [UIImage imageNamed:@"login-image-bg.png"];
    [self.view addSubview:backgroundImgView];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ORIGIN_HEIGHT, 389/2, 147/2)];
    logoImgView.center = CGPointMake(self.view.center.x, logoImgView.center.y);
    logoImgView.image = [UIImage imageNamed:@"logo-login.png"];
    [self.view addSubview:logoImgView];
    
    if (txtPhoneNumber == nil) {
        txtPhoneNumber = [XXTextField textFieldWithPoint:CGPointMake(0, logoImgView.frame.origin.y+logoImgView.frame.size.height+40)];
        txtPhoneNumber.center = CGPointMake(self.view.center.x, txtPhoneNumber.center.y);
        txtPhoneNumber.placeholder = NSLocalizedString(@"phone.number", @"");
        txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:txtPhoneNumber];
    }
    
    if (txtPassword == nil) {
        txtPassword = [XXTextField textFieldWithPoint:CGPointMake(0, txtPhoneNumber.frame.origin.y+txtPhoneNumber.frame.size.height+20)];
        txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
        txtPassword.placeholder = NSLocalizedString(@"password", @"");
        txtPassword.secureTextEntry = YES;
        txtPassword.returnKeyType = UIReturnKeyJoin;
        txtPassword.delegate = self;
        [self.view addSubview:txtPassword];
    }
    
    if (btnLogin == nil) {
        btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y+txtPassword.frame.size.height+20, 400/2, 53/2)];
        btnLogin.center = CGPointMake(self.view.center.x,btnLogin.center.y);
        [btnLogin setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
        [btnLogin setImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
        [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLogin addTarget:self action:@selector(btnLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogin];
    }
    
    UILabel *lblSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, 5, 44)];
    lblSeperator.text = @"|";
    lblSeperator.font = [UIFont systemFontOfSize:16.0f];
    lblSeperator.backgroundColor = [UIColor clearColor];
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
    NSString *userName = [XXStringUtils trim:txtPhoneNumber.text];
    NSString *password = [XXStringUtils trim:txtPassword.text];
    
    if([XXStringUtils isBlank:userName]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"username_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:password]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *accountService = [[AccountService alloc] init];

    [accountService loginWithAccount:txtPhoneNumber.text password:txtPassword.text success:@selector(loginSuccess:) failed:@selector(loginFailed:) target:self callback:nil];
}

- (void)loginSuccess:(RestResponse *)resp {
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
                        [[CoreService defaultService] startRefreshCurrentUnit];
                        
                        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess];
                        [[AlertView currentAlertView] delayDismissAlertView];
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
    [self.navigationController pushViewController:[[ForgetPasswordViewController alloc] init] animated:YES];
}

- (void)btnRegisterPressed:(id)sender {
    RegisterStep1ViewController *registerStep1ViewController = [[RegisterStep1ViewController alloc] init];
    [self.navigationController pushViewController:registerStep1ViewController animated:YES];
}

- (void)toMainPage {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([txtPassword isEqual:textField]) {
        [self btnLoginPressed:btnLogin];
        return YES;
    }
    return  NO;
}

@end
