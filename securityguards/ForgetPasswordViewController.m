//
//  ForgetPasswordViewController.m
//  securityguards
//
//  Created by hadoop user account on 30/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AccountService.h"

#define TOPBAR_HEIGHT   self.topbarView.frame.size.height

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController{
    UITextField *txtPhoneNumber;
    UIButton    *btnGetPasswordBack;
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
    self.topbarView.title = NSLocalizedString(@"forget.password", @"");
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, TOPBAR_HEIGHT+5, 80, 44)];
    lblPhoneNumber.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"phone.number", @"")];
    lblPhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPhoneNumber];
    
    if (txtPhoneNumber == nil) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(85, TOPBAR_HEIGHT+5, 200, 44)];
        txtPhoneNumber.placeholder = NSLocalizedString(@"please.input.phone.number.you.registered", @"");
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPhoneNumber.autocorrectionType = UITextAutocapitalizationTypeNone;
        txtPhoneNumber.font = [UIFont systemFontOfSize:15.f];
        txtPhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        [txtPhoneNumber becomeFirstResponder];
        txtPhoneNumber.delegate = self;
        [self.view addSubview:txtPhoneNumber];
    }
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblPhoneNumber.frame.size.height+lblPhoneNumber.frame.origin.y+5, self.view.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];
    
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y+10,200,60)];
    lblTip.numberOfLines = 2;
    lblTip.center = CGPointMake(self.view.center.x, lblTip.center.y);
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:11.f];
    lblTip.text = NSLocalizedString(@"forget.password.tip", @"");
    [self.view addSubview:lblTip];
    
    if (btnGetPasswordBack == nil) {
        btnGetPasswordBack = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.size.height+lblTip.frame.origin.y+10, 400/2, 53/2)];
        [btnGetPasswordBack setTitle:NSLocalizedString(@"get.new.password", @"") forState:UIControlStateNormal];
        [btnGetPasswordBack setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
        [btnGetPasswordBack setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
        [btnGetPasswordBack setImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
        [btnGetPasswordBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGetPasswordBack.center = CGPointMake(self.view.center.x, btnGetPasswordBack.center.y);
        [btnGetPasswordBack addTarget:self action:@selector(btnGetPasswordBackPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnGetPasswordBack];
    }

}

#pragma mark-
#pragma mark button actions

- (void)btnGetPasswordBackPressed:(id) sender{
    NSString *phoneNumber = [XXStringUtils trim:txtPhoneNumber.text];
    if([XXStringUtils isBlank:phoneNumber] || phoneNumber.length != 11) {
        [[[AccountService alloc] init] sendPasswordToMobile:phoneNumber success:@selector(sendPasswordSuccess:) failed:@selector(sendPasswordFailed:) target:self callback:nil];
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alert:YES isLock:YES];
    }
    
    [[[AccountService alloc] init] sendPasswordToMobile:phoneNumber success:@selector(sendPasswordSuccess:) failed:@selector(sendPasswordFailed:) target:self callback:nil];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alert:NO isLock:YES];
}

- (void)sendPasswordSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *result = [json stringForKey:@"id"];
            if(result != nil) {
                if([@"1" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                } else if([@"-1" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-2" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_not_exists", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:result] || [@"-4" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delay_send", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-5" isEqualToString:result] || [@"-6" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_failed", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self sendPasswordFailed:resp];
}

- (void)sendPasswordFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeSuccess];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return range.location<11;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
