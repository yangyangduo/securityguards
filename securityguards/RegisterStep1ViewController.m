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
#import "DeclareViewController.h"

@interface RegisterStep1ViewController ()

@end

@implementation RegisterStep1ViewController{
    UITextField *txtPhoneNumber;
    UIButton *btnAgree;
    UIButton *btnGetVerificationCode;
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

    if (btnGetVerificationCode == nil) {
        
        btnGetVerificationCode= [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.size.height+lblTip.frame.origin.y + 10, 460 / 2, 60 / 2)];
        [btnGetVerificationCode setTitle:NSLocalizedString(@"get_verification_code", @"") forState:UIControlStateNormal];
        [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
        [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
        [btnGetVerificationCode setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
        [btnGetVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGetVerificationCode.center = CGPointMake(self.view.center.x, btnGetVerificationCode.center.y);
        [btnGetVerificationCode addTarget:self action:@selector(btnGetVerificationPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnGetVerificationCode];

    }

    if(isModify) {
        
        lblTip.text = NSLocalizedString(@"modify_tip", @"");
        
        [btnGetVerificationCode setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    }else{
        lblTip.text = NSLocalizedString(@"register_tips1", @"");
        [btnGetVerificationCode setTitle:NSLocalizedString(@"get_verification_code", @"") forState:UIControlStateNormal];
        btnAgree = [[UIButton alloc] initWithFrame:CGRectMake(48, btnGetVerificationCode.frame.origin.y +btnGetVerificationCode.frame.size.height - 3, 44, 44)];
        [btnAgree setBackgroundImage:[UIImage imageNamed:@"checkbox_unselected.png"] forState:UIControlStateNormal];
        [btnAgree setBackgroundImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateSelected];
        btnAgree.selected = YES;
        [btnAgree addTarget:self action:@selector(btnAgreePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAgree];
        
        UILabel *lblAgree = [[UILabel alloc] initWithFrame:CGRectMake(92, btnAgree.frame.origin.y, 100, 44)];
        lblAgree.textColor = [UIColor darkGrayColor];
        lblAgree.font = [UIFont systemFontOfSize:14.f];
        lblAgree.text = NSLocalizedString(@"read_and_agree", @"");
        [self.view addSubview:lblAgree];
        
        UIButton *btnDeclare = [[UIButton alloc] initWithFrame:CGRectMake(200, btnAgree.frame.origin.y, 60, 44)];
        btnDeclare.backgroundColor = [UIColor clearColor];
        [btnDeclare setTitleColor:[UIColor appLightBlue] forState:UIControlStateNormal];
        [btnDeclare setTitleColor:[UIColor appBlue] forState:UIControlStateHighlighted];
        btnDeclare.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btnDeclare setTitle:NSLocalizedString(@"declare_title", @"") forState:UIControlStateNormal];
        [btnDeclare addTarget:self action:@selector(btnDeclarePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeclare];
    
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
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *accountService = [[AccountService alloc] init];
    if(isModify) {
        [accountService sendModifyUsernameVerificationCodeFor:txtPhoneNumber.text success:@selector(sendVerificationCodeSuccess:) failed:@selector(sendVerificationCodeFailed:) target:self callback:nil];
    }else{
        [accountService sendVerificationCodeFor:txtPhoneNumber.text success:@selector(sendVerificationCodeSuccess:) failed:@selector(sendVerificationCodeFailed:) target:self callback:nil];
    }
}

- (void)btnAgreePressed:(UIButton *)sender{
    btnAgree.selected = !btnAgree.selected;
    btnGetVerificationCode.enabled = btnAgree.selected;
}

- (void)btnDeclarePressed:(UIButton *)sender{
    [self.navigationController pushViewController:[[DeclareViewController alloc] init] animated:YES];
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
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
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
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if(([@"-2" isEqualToString:result] && !isModify)||([@"-7" isEqualToString:result] && isModify)) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"phone_has_been_register", @"") forType:AlertViewTypeSuccess];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self sendVerificationCodeFailed:resp];
}

- (void)sendVerificationCodeFailed:(RestResponse *)resp {
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
    return range.location < 11;
}

@end
