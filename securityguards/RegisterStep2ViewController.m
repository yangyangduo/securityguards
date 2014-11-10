//
//  RegisterStep2ViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RegisterStep2ViewController.h"
#import "LoginViewController.h"
#import "AccountService.h"
#import "XXTextField.h"
#import "DeviceCommand.h"
#import "Shared.h"

#import "LoginViewController.h"
#import "AccountSettingsViewController.h"

#define TOPBAR_HEIGHT   self.topbarView.frame.size.height

@interface RegisterStep2ViewController ()

@end

@implementation RegisterStep2ViewController{
    UITextField *txtVerificationCode;
    UITextField *txtPassword;
    UIButton *btnResendVerificationCode;

    NSTimer *countDownTimer;
    UIAlertView * checkPassword;
}

@synthesize phoneNumber;
@synthesize countDown;
@synthesize isModify;

- (id)initAsModify:(BOOL)modify{
    self = [super init];
    if (self) {
        isModify = modify;
    }
    return self;
}

- (void)initUI{
    [super initUI];
    
    self.topbarView.title = isModify?NSLocalizedString(@"modify_title", @""): NSLocalizedString(@"register_title", @"");
    
    UILabel *lblVerificationCode = [[UILabel alloc] initWithFrame:CGRectMake(5, self.topbarView.bounds.size.height + 5, 80, 44)];
    lblVerificationCode.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"verification_code", @"")];
    lblVerificationCode.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblVerificationCode];
    
    txtVerificationCode = [[UITextField alloc] initWithFrame:CGRectMake(85, lblVerificationCode.frame.origin.y + 2, 200, 44)];
    txtVerificationCode.placeholder = NSLocalizedString(@"enter_verification_code", @"");
    txtVerificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtVerificationCode.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtVerificationCode.keyboardType = UIKeyboardTypeNumberPad;
    txtVerificationCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtVerificationCode.delegate = self;
    [self.view addSubview:txtVerificationCode];
    
    UIView *seperatorView1 = [[UIView alloc] initWithFrame:CGRectMake(0, lblVerificationCode.frame.size.height +lblVerificationCode.frame.origin.y + 5, self.view.bounds.size.width, 1)];
    seperatorView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView1];
    
    UILabel *lblPassword = [[UILabel alloc] initWithFrame:CGRectMake(5, seperatorView1.frame.origin.y + seperatorView1.bounds.size.height + 5, 80, 44)];
    lblPassword.text = [NSString stringWithFormat:@"%@ :", @"新密码"];
    lblPassword.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPassword];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(85, lblPassword.frame.origin.y + 2, 200, 44)];
    txtPassword.placeholder = @"请输入新密码";
    txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPassword.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtPassword.keyboardType = UIKeyboardTypeASCIICapable;
    txtPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:txtPassword];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblPassword.frame.size.height+lblPassword.frame.origin.y+5, self.view.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];

    /*
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y+10,200,60)];
    lblTip.numberOfLines = 2;
    lblTip.center = CGPointMake(self.view.center.x, lblTip.center.y);
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:11.f];
    lblTip.text = NSLocalizedString(@"register_tips2", @"");
    [self.view addSubview:lblTip]; */

    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, seperatorView.frame.origin.y+seperatorView.frame.size.height + 10, 460 / 2, 60 / 2)];
    btnRegister.center = CGPointMake(self.view.center.x, btnRegister.center.y);
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(btnRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnRegister setTitle:isModify?NSLocalizedString(@"submit", @""): NSLocalizedString(@"register_done", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnRegister];
    
    btnResendVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(0, btnRegister.frame.origin.y + btnRegister.frame.size.height + 5, 460 / 2, 60 / 2)];
    btnResendVerificationCode.center = CGPointMake(self.view.center.x, btnResendVerificationCode.center.y);
    [btnResendVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnResendVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnResendVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];

    
    [btnResendVerificationCode setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"resend_verification_code", @"")] forState:UIControlStateNormal];
    [btnResendVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnResendVerificationCode setTitle:[NSString stringWithFormat:@"%@ (%i)",NSLocalizedString(@"resend_verification_code", @""), self.countDown] forState:UIControlStateDisabled];
    
    [btnResendVerificationCode addTarget:self action:@selector(btnResendVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.countDown > 0) {
        btnResendVerificationCode.enabled = NO;
    }
    
    [self.view addSubview:btnResendVerificationCode];
}

- (void)setUp {
    [super setUp];
    if(self.countDown > 0) {
        [self startCountDown];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if(!txtVerificationCode.isFirstResponder) {
        [txtVerificationCode becomeFirstResponder];
    }
}

#pragma mark-
#pragma mark UI Actions

- (void)btnRegisterPressed:(id) sender{
    if (isModify) {
        [self submitVerificationCodeAndOldPassword];
    }else{
        [self submitVerificationCode];
    }
}

- (void)btnResendVerificationCode:(id) sender{
    [self resendVerificationCode];
}

#pragma mark-
#pragma mark modify username

- (void)submitVerificationCodeAndOldPassword{
    if (checkPassword == nil) {
        checkPassword = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password_valid", @"") message:NSLocalizedString(@"enter_old_pwd", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
        [checkPassword setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        
        [checkPassword show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *oldPassword = [alertView textFieldAtIndex:0].text;
        if([XXStringUtils isBlank: oldPassword]) {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            return;
        }
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        [[[AccountService alloc] init] modifyUsernameByPhoneNumber:self.phoneNumber checkCode:txtVerificationCode.text oldPassword:oldPassword success:@selector(modifyUsernameSuccess:) failed:@selector(registerFailed:) target:self callback:nil
         ];
    }
}

- (void)modifyUsernameSuccess:(RestResponse *)resp{
    if (resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSInteger resultID = [[json noNilStringForKey:@"id"] integerValue];
            switch (resultID) {
                case 1:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    [GlobalSettings defaultSettings].account = phoneNumber;
                    [[GlobalSettings defaultSettings] saveSettings];
                    
                    [[checkPassword textFieldAtIndex:0] resignFirstResponder];
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[AccountSettingsViewController class]]) {
                            [self.navigationController popToViewController:controller animated:NO];
                            [(AccountSettingsViewController *) controller updateUsername:self.phoneNumber];
                        }
                    }
                    break;
                case -1:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"none_verification_code", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    break;
                case -2:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    break;
                case -3:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    break;
                case -4:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"id_is_not_found", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    break;
                case -5:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"pwd_invalid", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    break;
                case -6:
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"system_exception", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    break;
                default:
                    break;
            }
        }
        
        return;
    }
    [self registerFailed:resp];
}


#pragma mark-
#pragma mark countdown


- (void)startCountDown {
    if(countDownTimer != nil && countDownTimer.isValid) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownForResend) userInfo:nil repeats:YES];
}

- (void)countDownForResend {
    if (countDown > 0) {
        countDown--;
        [btnResendVerificationCode setTitle:[NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"resend_verification_code", @""), self.countDown] forState:UIControlStateDisabled];
    } else {
        [countDownTimer invalidate];
        countDownTimer = nil;
        btnResendVerificationCode.enabled = YES;
    }
}

#pragma mark-
#pragma mark Services

- (void)resendVerificationCode {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [[[AccountService alloc] init] sendVerificationCodeFor:self.phoneNumber success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
}

- (void)verificationCodeSendSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *_id_ = [json notNSNullObjectForKey:@"id"];
            if(_id_ != nil) {
                if([@"1" isEqualToString:_id_]) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    self.countDown = 60;
                    [btnResendVerificationCode setTitle:[NSString stringWithFormat:@"%@ (%i)",NSLocalizedString(@"resend_verification_code", @""),countDown] forState:UIControlStateDisabled];
                    btnResendVerificationCode.enabled = NO;
                    [self startCountDown];
                    return;
                }
            }
        }
    }
    [self verificationCodeSendError:resp];
}

- (void)verificationCodeSendError:(RestResponse *)resp {
    if(resp.statusCode == 1001) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else if(resp.statusCode == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeSuccess];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeSuccess];
    }
    [[XXAlertView currentAlertView] delayDismissAlertView];
}

- (void)submitVerificationCode {
    if([XXStringUtils isBlank:txtVerificationCode.text] || txtVerificationCode.text.length != 6) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:txtPassword.text]) {
        [[XXAlertView currentAlertView] setMessage:@"密码格式错误" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    [[[AccountService alloc] init] regWithMobile:self.phoneNumber pwd:txtPassword.text checkCode:txtVerificationCode.text success:@selector(registerSuccessfully:) failed:@selector(registerFailed:) target:self callback:nil];
}

- (void)registerSuccessfully:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            DeviceCommand *command = [[DeviceCommand alloc] initWithDictionary:json];
            if(command != nil && ![XXStringUtils isBlank:command.result]) {
                if([@"1" isEqualToString:command.result]) {
                    if(![XXStringUtils isBlank:command.security] && ![XXStringUtils isBlank:command.tcpAddress]) {
                        [[XXAlertView currentAlertView] dismissAlertView];
                        GlobalSettings *settings = [GlobalSettings defaultSettings];
                        settings.secretKey = command.security;
                        settings.account = self.phoneNumber;
                        settings.tcpAddress = command.tcpAddress;
                        settings.deviceCode = command.deviceCode;
                        settings.restAddress = command.restAddress;
                        [settings saveSettings];
                        LoginViewController *loginViewController = nil;
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isMemberOfClass:[LoginViewController class]]) {
                                loginViewController = (LoginViewController *)vc;
                            }
                        }
                        [[CoreService defaultService] startService];
                        [self.navigationController popToViewController:loginViewController animated:NO];
                        [loginViewController dismissViewControllerAnimated:NO completion:^{}];
                        return;
                    }
                } else if([@"-1" isEqualToString:command.result]) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"none_verification_code", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-2" isEqualToString:command.result]) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:command.result]) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self registerFailed:resp];
}

- (void)registerFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[XXAlertView currentAlertView] delayDismissAlertView];
}

#pragma mark -
#pragma mark Text View Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return range.location < 6;
}

@end
