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
    [self initUI];
}

- (void)initUI{
    [super initUI];
    
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, TOPBAR_HEIGHT+20, 80, 44)];
    lblPhoneNumber.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"phone.number", @"")];
    lblPhoneNumber.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lblPhoneNumber];
    
    if (txtPhoneNumber) {
        txtPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(50, TOPBAR_HEIGHT+20, 200, 44)];
        txtPhoneNumber.placeholder = NSLocalizedString(@"please.input.phone.number.for.registerring", @"");
        [self.view addSubview:txtPhoneNumber];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
