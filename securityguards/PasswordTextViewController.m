//
//  PasswordTextViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PasswordTextViewController.h"

@interface PasswordTextViewController ()

@end

@implementation PasswordTextViewController {
    UITextField *textField;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [super initUI];
    
    [self setTxtDescription:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"enter_new_pwd", @"")]];
    
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:TEXT_FIELD_TAG];
    textField1.secureTextEntry = YES;
    UIButton *btnSubmit = (UIButton *)[self.view viewWithTag:SUBMIT_BUTTON_TAG];
    
    UILabel *lblTextDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, textField1.frame.origin.y + textField1.bounds.size.height + 5, 250, 30)];
    lblTextDescription.font = [UIFont systemFontOfSize:13.f];
    lblTextDescription.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"enter_pwd_again", @"")];
    lblTextDescription.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblTextDescription];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, lblTextDescription.frame.origin.y + lblTextDescription.bounds.size.height + 5, [UIScreen mainScreen].bounds.size.width, 30)];
    textField.secureTextEntry = YES;
    textField.backgroundColor = [UIColor whiteColor];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.textColor = [UIColor darkGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    btnSubmit.center = CGPointMake(btnSubmit.center.x, textField.center.y + 45);
}


- (void)btnSubmitPressed:(id)sender {
    
    if(![self.value isEqualToString:textField.text]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"pwd_different", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:self.value]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [super btnSubmitPressed:sender];
}

@end
