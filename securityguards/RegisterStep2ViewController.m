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

@interface RegisterStep2ViewController ()

@end

@implementation RegisterStep2ViewController{
    UITextField *txtVerificationCode;
    UIButton *btnResendVerificationCode;

    NSTimer *countDownTimer;
}

@synthesize phoneNumber;
@synthesize countDown;

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

- (void)initUI{
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"register_title", @"");
    
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
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblVerificationCode.frame.size.height+lblVerificationCode.frame.origin.y+5, self.view.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];

    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y+10,200,60)];
    lblTip.numberOfLines = 2;
    lblTip.center = CGPointMake(self.view.center.x, lblTip.center.y);
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:11.f];
    lblTip.text = NSLocalizedString(@"register_tips2", @"");
    [self.view addSubview:lblTip];

    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.origin.y+lblTip.frame.size.height+5, 460 / 2, 60 / 2)];
    btnRegister.center = CGPointMake(self.view.center.x, btnRegister.center.y);
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(btnRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnRegister setTitle:NSLocalizedString(@"register_done", @"") forState:UIControlStateNormal];
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
    [self submitVerificationCode];
}

- (void)btnResendVerificationCode:(id) sender{
    [self resendVerificationCode];
}

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
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [[[AccountService alloc] init] sendVerificationCodeFor:self.phoneNumber success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
}

- (void)verificationCodeSendSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *_id_ = [json notNSNullObjectForKey:@"id"];
            if(_id_ != nil) {
                if([@"1" isEqualToString:_id_]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
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
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else if(resp.statusCode == 1004) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeSuccess];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeSuccess];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)submitVerificationCode {
    if([XXStringUtils isBlank:txtVerificationCode.text] || txtVerificationCode.text.length != 6) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [[[AccountService alloc] init] registerWithPhoneNumber:self.phoneNumber checkCode:txtVerificationCode.text success:@selector(registerSuccessfully:) failed:@selector(registerFailed:) target:self callback:nil];
}

- (void)registerSuccessfully:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            DeviceCommand *command = [[DeviceCommand alloc] initWithDictionary:json];
            if(command != nil && ![XXStringUtils isBlank:command.result]) {
                if([@"1" isEqualToString:command.result]) {
                    if(![XXStringUtils isBlank:command.security] && ![XXStringUtils isBlank:command.tcpAddress]) {
                        [[AlertView currentAlertView] dismissAlertView];
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
                        [[CoreService defaultService] startRefreshCurrentUnit];
                        [self.navigationController popToViewController:loginViewController animated:NO];
                        [loginViewController dismissViewControllerAnimated:NO completion:^{}];
                        return;
                    }
                } else if([@"-1" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"none_verification_code", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-2" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self registerFailed:resp];
}

- (void)registerFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

#pragma mark -
#pragma mark Text View Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return range.location < 6;
}

@end
