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

@interface RegisterStep1ViewController ()

@end

@implementation RegisterStep1ViewController{
    UITextField *txtPhoneNumber;
    UIButton *btnAgree;
}

@synthesize isModify;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initAsModify:(BOOL)modify{
    self = [super init];
    if (self) {
        isModify = modify;
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

    self.topbarView.title = isModify?NSLocalizedString(@"modify_title", @""): NSLocalizedString(@"register_title", @"");
    
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, self.topbarView.bounds.size.height + 5, 80, 44)];
    lblPhoneNumber.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"phone_number", @"")];
    lblPhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPhoneNumber];
    
    txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(85, self.topbarView.bounds.size.height + 7, 200, 44)];
    txtPhoneNumber.placeholder = isModify?NSLocalizedString(@"phone_modify_placeholder", @""): NSLocalizedString(@"phone_text_placeholder", @"");
    txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPhoneNumber.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPhoneNumber.delegate =self;
    txtPhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:txtPhoneNumber];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblPhoneNumber.frame.size.height+lblPhoneNumber.frame.origin.y+5, self.view.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];
    
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y + 10, 200, 60)];
    lblTip.numberOfLines = 2;
    lblTip.center = CGPointMake(self.view.center.x, lblTip.center.y);
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:11.f];
    [self.view addSubview:lblTip];


    UIButton *btnGetVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.size.height+lblTip.frame.origin.y + 10, 460 / 2, 60 / 2)];
    [btnGetVerificationCode setTitle:NSLocalizedString(@"get_verification_code", @"") forState:UIControlStateNormal];
    [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnGetVerificationCode setImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnGetVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGetVerificationCode.center = CGPointMake(self.view.center.x, btnGetVerificationCode.center.y);
    [btnGetVerificationCode addTarget:self action:@selector(btnGetVerificationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGetVerificationCode];


    if(isModify) {
        
        lblTip.text = NSLocalizedString(@"modify_tip", @"");
        
        [btnGetVerificationCode setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    }else{
        lblTip.text = NSLocalizedString(@"register_tips1", @"");
        [btnGetVerificationCode setTitle:NSLocalizedString(@"get_verification_code", @"") forState:UIControlStateNormal];
        btnAgree = [[UIButton alloc] initWithFrame:CGRectMake(150, btnGetVerificationCode.frame.origin.y+btnGetVerificationCode.frame.size.height+5, 44, 44)];
        [self.view addSubview:btnAgree];
    
    }

}

- (void)viewWillAppear:(BOOL)animated {
    if(!txtPhoneNumber.isFirstResponder) {
        [txtPhoneNumber becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark UI Actions

- (void)btnGetVerificationPressed:(id)sender {    
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *accountService = [[AccountService alloc] init];
    if(isModify) {
        [accountService sendModifyUsernameVerificationCodeFor:txtPhoneNumber.text success:@selector(sendVerificationCodeSuccess:) failed:@selector(sendVerificationCodeFailed:) target:self callback:nil];
    }else{
        [accountService sendVerificationCodeFor:txtPhoneNumber.text success:@selector(sendVerificationCodeSuccess:) failed:@selector(sendVerificationCodeFailed:) target:self callback:nil];
    }
}

#pragma mark -
#pragma mark Service

- (void)sendVerificationCodeSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *result = [json notNSNullObjectForKey:@"id"];
            if(result != nil) {
                if([@"1" isEqualToString:result] || [@"-3" isEqualToString:result] || [@"-4" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    RegisterStep2ViewController *step2ViewController = [[RegisterStep2ViewController alloc] initAsModify:self.isModify];
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
                } else if(([@"-2" isEqualToString:result] && !isModify)||([@"-7" isEqualToString:result] && isModify)) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_has_been_register", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self sendVerificationCodeFailed:resp];
}

- (void)sendVerificationCodeFailed:(RestResponse *)resp {
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
    return range.location < 11;
}

@end
