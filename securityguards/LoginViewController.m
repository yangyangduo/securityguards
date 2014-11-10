//
//  LoginViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterStep1ViewController.h"
#import "ForgetPasswordViewController.h"
#import "XXTextField.h"
#import "DeviceCommand.h"
#import "AccountService.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UITextField *txtPhoneNumber;
    UITextField *txtPassword;
}

@synthesize hasLogin;

- (void)initUI{
    [super initUI];
    
    [self registerTapGestureToResignKeyboard];
    
    UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImgView.image = [UIImage imageNamed:@"bg_login"];
    [self.view addSubview:backgroundImgView];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 72 : 52, 389/2, 147/2)];
    imgLogo.center = CGPointMake(self.view.center.x, imgLogo.center.y);
    imgLogo.image = [UIImage imageNamed:@"logo_gold"];
    [self.view addSubview:imgLogo];

    txtPhoneNumber = [XXTextField textFieldWithPoint:CGPointMake(0, imgLogo.frame.origin.y + imgLogo.frame.size.height + 30)];
    txtPhoneNumber.center = CGPointMake(self.view.center.x, txtPhoneNumber.center.y);
    txtPhoneNumber.placeholder = NSLocalizedString(@"phone_number", @"");
    txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:txtPhoneNumber];

    txtPassword = [XXTextField textFieldWithPoint:CGPointMake(0, txtPhoneNumber.frame.origin.y + txtPhoneNumber.frame.size.height + 20)];
    txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
    txtPassword.placeholder = NSLocalizedString(@"password", @"");
    txtPassword.secureTextEntry = YES;
    txtPassword.returnKeyType = UIReturnKeyJoin;
    txtPassword.delegate = self;
    [self.view addSubview:txtPassword];

    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y+txtPassword.frame.size.height + 20, 460 / 2, 60 / 2)];
    btnLogin.center = CGPointMake(self.view.center.x,btnLogin.center.y);
    [btnLogin setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnLogin setImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    UILabel *lblSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, 5, 44)];
    lblSeperator.text = @"|";
    lblSeperator.font = [UIFont systemFontOfSize:16.0f];
    lblSeperator.backgroundColor = [UIColor clearColor];
    lblSeperator.center = CGPointMake(self.view.center.x, lblSeperator.center.y);
    [self.view addSubview:lblSeperator];

    UIButton *btnForgetPassword = [[UIButton alloc] initWithFrame:CGRectMake(lblSeperator.frame.origin.x-80, self.view.frame.size.height - 64, 80, 44)];
    [btnForgetPassword setTitle:NSLocalizedString(@"forget_password", @"") forState:UIControlStateNormal];
    btnForgetPassword.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btnForgetPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnForgetPassword addTarget:self action:@selector(btnForgetPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnForgetPassword];

    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(lblSeperator.frame.origin.x + 5, btnForgetPassword.frame.origin.y, 80, 44)];
    [btnRegister setTitle:NSLocalizedString(@"register", @"") forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnRegister setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(btnRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
}

#pragma mark-
#pragma mark UI Action

- (void)btnLoginPressed:(id)sender {
    NSString *userName = [XXStringUtils trim:txtPhoneNumber.text];
    NSString *password = [XXStringUtils trim:txtPassword.text];
    
    if([XXStringUtils isBlank:userName]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"username_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:password]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *accountService = [[AccountService alloc] init];

    [accountService loginWithAccount:txtPhoneNumber.text password:txtPassword.text success:@selector(loginSuccess:) failed:@selector(loginFailed:) target:self callback:nil];
}

- (void)btnForgetPasswordPressed:(id)sender {
    [self.navigationController pushViewController:[[ForgetPasswordViewController alloc] init] animated:YES];
}

- (void)btnRegisterPressed:(id)sender {
    [self.navigationController pushViewController:[[RegisterStep1ViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark Login Service

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
#ifdef DEBUG
                        NSLog(@"security key is [%@]", command.security);
#endif
                        
                        // register for remote notifications
                        AppDelegate *app = [UIApplication sharedApplication].delegate;
                        [app registerForRemoteNotifications];
                        
                        // start service
                        [[CoreService defaultService] startService];
                        
                        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess];
                        [[XXAlertView currentAlertView] delayDismissAlertView];
                        
                        [self dismissViewControllerAnimated:NO completion:^{}];
                        return;
                    }
                } else if([@"-1" isEqualToString:command.result] || [@"-2" isEqualToString:command.result]) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"name_or_pwd_error", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:command.result] || [@"-4" isEqualToString:command.result]) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"login_later", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self loginFailed:resp];
}

- (void)loginFailed:(RestResponse *) resp{
    if(abs(resp.statusCode) == 1001) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    }  else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    }
    [[XXAlertView currentAlertView] delayDismissAlertView];
}

#pragma mark -
#pragma mark Text View Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([txtPassword isEqual:textField]) {
        [self btnLoginPressed:nil];
        return YES;
    }
    return  NO;
}

@end
