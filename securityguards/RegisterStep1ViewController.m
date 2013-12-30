//
//  RegisterStep1ViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RegisterStep1ViewController.h"
#import "RegisterStep2ViewController.h"
#import "AccountService.h"
#import "AlertView.h"
#import "JsonUtils.h"
#import "NSDictionary+Extension.h"
#define TOPBAR_HEIGHT   self.topbarView.frame.size.height

@interface RegisterStep1ViewController ()

@end

@implementation RegisterStep1ViewController{
    UITextField *txtPhoneNumber;
    UIButton    *btnGetVerificationCode;
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

- (void)initUI{
    [super initUI];
    [self registerTapGestureToResignKeyboard];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topbarView.title = NSLocalizedString(@"register.account", @"");
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, TOPBAR_HEIGHT+20, 80, 44)];
    lblPhoneNumber.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"phone.number", @"")];
    lblPhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPhoneNumber];
    
    if (txtPhoneNumber == nil) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(85, TOPBAR_HEIGHT+20, 200, 44)];
        txtPhoneNumber.placeholder = NSLocalizedString(@"please.input.phone.number.for.registerring", @"");
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPhoneNumber.autocorrectionType = UITextAutocapitalizationTypeNone;
//        txtPhoneNumber.font = [UIFont systemFontOfSize:14.f];
        txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:txtPhoneNumber];
    }
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblPhoneNumber.frame.size.height+lblPhoneNumber.frame.origin.y+5, self.view.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];
    
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y+10,200,100)];
    lblTip.numberOfLines = 2;
    lblTip.center = CGPointMake(self.view.center.x, lblTip.center.y);
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:11.f];
    lblTip.text = NSLocalizedString(@"register.tip1", @"");
    [self.view addSubview:lblTip];
    
    if (btnGetVerificationCode == nil) {
        btnGetVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.size.height+lblTip.frame.origin.y+10, 400/2, 53/2)];
        [btnGetVerificationCode setTitle:NSLocalizedString(@"get.verification", @"") forState:UIControlStateNormal];
        [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
        [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
        [btnGetVerificationCode setImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
        [btnGetVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGetVerificationCode.center = CGPointMake(self.view.center.x, btnGetVerificationCode.center.y);
        [btnGetVerificationCode addTarget:self action:@selector(btnGetVerificationPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnGetVerificationCode];
    }
    
    
}

#pragma mark-
#pragma mark button actions

- (void)btnGetVerificationPressed:(id) sender{
    AccountService *accountService = [[AccountService alloc] init];
    [accountService sendVerificationCodeFor:txtPhoneNumber.text success:@selector(sendVerificationCodeSuccess:) failed:@selector(sendVerificationCodeFailed:) target:self callback:nil];
    RegisterStep2ViewController *step2ViewController = [[RegisterStep2ViewController alloc] init];
    step2ViewController.countDown = 60;
    [self.navigationController pushViewController:step2ViewController animated:YES];
    
}

- (void)sendVerificationCodeSuccess:(RestResponse *) resp{
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *result = [json notNSNullObjectForKey:@"id"];
            if(result != nil) {
                if([@"1" isEqualToString:result] || [@"-3" isEqualToString:result] || [@"-4" isEqualToString:result]) {
                    [[AlertView currentAlertView] dismissAlertView];
                    RegisterStep2ViewController *step2ViewController = [[RegisterStep2ViewController alloc] init];
                    step2ViewController.phoneNumber = txtPhoneNumber.text;
                    
                    if([@"1" isEqualToString:result]) {
                        step2ViewController.countDown = 60;
                    } else {
                        NSNumber *num = (NSNumber *)[json notNSNullObjectForKey:@"wait"];
                        if(num != nil) {
                            step2ViewController.countDown = num.integerValue;
                        } else {
                            step2ViewController.countDown = 60;
                        }
                    }
                    [self.navigationController pushViewController:step2ViewController animated:YES];
                    return;
                } else if([@"-1" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-2" isEqualToString:result]||[@"-7" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_has_been_register", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self sendVerificationCodeFailed:resp];
}

- (void)sendVerificationCodeFailed:(RestResponse *) resp{
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
