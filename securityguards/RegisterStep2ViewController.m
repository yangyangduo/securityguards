//
//  RegisterStep2ViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RegisterStep2ViewController.h"
#define TOPBAR_HEIGHT   self.topbarView.frame.size.height

@interface RegisterStep2ViewController ()

@end

@implementation RegisterStep2ViewController{
    UITextField *txtPhoneNumber;
    UITextField *txtVerificationCode;
    UIButton *btnRegister;
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

- (void)initUI{
    [super initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topbarView.title = NSLocalizedString(@"register.account", @"");
    
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, TOPBAR_HEIGHT+20, 80, 44)];
    lblPhoneNumber.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"phone.number", @"")];
    lblPhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPhoneNumber];

    UILabel *lblVerificationCode = [[UILabel alloc] initWithFrame:CGRectMake(5, lblPhoneNumber.frame.origin.y+lblPhoneNumber.frame.size.height+5, 80, 44)];
    lblVerificationCode.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"verification.code", @"")];
    lblVerificationCode.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblVerificationCode];

    if (txtPhoneNumber == nil) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(85, 20+TOPBAR_HEIGHT, 200, 44)];
        txtPhoneNumber.text = phoneNumber;
        [self.view addSubview:txtPhoneNumber];
    }
    
    if (txtVerificationCode == nil) {
        txtVerificationCode = [[UITextField alloc] initWithFrame:CGRectMake(85, lblVerificationCode.frame.origin.y, 200, 44)];
        txtVerificationCode.placeholder = NSLocalizedString(@"please.input.verification.code", @"");
        txtVerificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtVerificationCode.autocorrectionType = UITextAutocapitalizationTypeNone;
        [self.view addSubview:txtVerificationCode];
    }
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblVerificationCode.frame.size.height+lblVerificationCode.frame.origin.y+5, self.view.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];

    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y+10,200,100)];
    lblTip.numberOfLines = 2;
    lblTip.center = CGPointMake(self.view.center.x, lblTip.center.y);
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:11.f];
    lblTip.text = NSLocalizedString(@"register.tip2", @"");
    [self.view addSubview:lblTip];
    
    if (btnRegister == nil) {
        btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.origin.y+lblTip.frame.size.height+10, 400/2, 53/2)];
        btnRegister.center = CGPointMake(self.view.center.x, btnRegister.center.y);
        [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnRegister setImage:[UIImage imageNamed:@"button-royalblue-400.png"] forState:UIControlStateNormal];
        [btnRegister setImage:[UIImage imageNamed:@"button-gray-400.png"] forState:UIControlStateDisabled];
        [btnRegister setImage:[UIImage imageNamed:@"button-skyblue-400.png"] forState:UIControlStateHighlighted];
        btnRegister.enabled = NO;
        [self.view addSubview:btnRegister];
    }
    
    if (btnResendVerificationCode == nil) {
        btnResendVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(0, btnRegister.frame.origin.y+btnRegister.frame.size.height+10, 400/2, 53/2)];
        btnResendVerificationCode.center = CGPointMake(self.view.center.x, btnResendVerificationCode.center.y);
        if (countDownTimer == nil) {
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownForResend) userInfo:nil repeats:YES];
        }
        [btnResendVerificationCode setTitle:[NSString stringWithFormat:@"%@(%i)",NSLocalizedString(@"resend.verification.code", @""),countDown] forState:UIControlStateDisabled];
        [btnResendVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnResendVerificationCode setImage:[UIImage imageNamed:@"button-royalblue-400.png"] forState:UIControlStateNormal];
        [btnResendVerificationCode setImage:[UIImage imageNamed:@"button-gray-400.png"] forState:UIControlStateDisabled];
        [btnResendVerificationCode setImage:[UIImage imageNamed:@"button-skyblue-400.png"] forState:UIControlStateHighlighted];
        btnResendVerificationCode.enabled = NO;
        [self.view addSubview:btnResendVerificationCode];
    }
    
}

#pragma mark-
#pragma mark btn actions



#pragma mark-
#pragma mark countdown
- (void)countDownForResend{
    if (countDown>0) {
        countDown--;
        [btnResendVerificationCode setTitle:[NSString stringWithFormat:@"%@(%iS)",NSLocalizedString(@"resend.verification.code", @""),countDown] forState:UIControlStateDisabled];
    }else{
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
