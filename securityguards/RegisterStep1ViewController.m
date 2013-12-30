//
//  RegisterStep1ViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RegisterStep1ViewController.h"
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.topbarView.title = NSLocalizedString(@"register.account", @"");
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, TOPBAR_HEIGHT+20, 80, 44)];
    lblPhoneNumber.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"phone.number", @"")];
    lblPhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPhoneNumber];
    
    if (txtPhoneNumber) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(50, TOPBAR_HEIGHT+20, 200, 44)];
        txtPhoneNumber.placeholder = NSLocalizedString(@"please.input.phone.number.for.registerring", @"");
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPhoneNumber.autocorrectionType = UITextAutocapitalizationTypeNone;
        txtPhoneNumber.font = [UIFont systemFontOfSize:15.f];
        [self.view addSubview:txtPhoneNumber];
    }
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, lblPhoneNumber.frame.size.height+lblPhoneNumber.frame.origin.y+5, self.view.bounds.size.width, 2)];
    seperatorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorView];
    
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, seperatorView.frame.size.height+seperatorView.frame.origin.y+10,200,100)];
    lblTip.numberOfLines = 2;
    lblTip.lineBreakMode = NSLineBreakByWordWrapping;
    lblTip.textColor = [UIColor lightTextColor];
    lblTip.text = NSLocalizedString(@"register.tip", @"");
    [self.view addSubview:lblTip];
    
    if (btnGetVerificationCode == nil) {
        btnGetVerificationCode = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTip.frame.size.height+lblTip.frame.origin.y+10, 400/2, 53/2)];
        [btnGetVerificationCode setTitle:NSLocalizedString(@"get.verification", @"") forState:UIControlStateNormal];
        [btnGetVerificationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGetVerificationCode.center = CGPointMake(self.view.center.x, btnGetVerificationCode.center.y);
        [self.view addSubview:btnGetVerificationCode];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
