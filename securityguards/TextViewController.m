//
//  TextViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController {
    UILabel *lblTextDescription;
    UITextField *textField;
}

@synthesize defaultValue = _defaultValue_;
@synthesize txtDescription = _txtDescription_;
@synthesize delegate;

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
    self.view.backgroundColor = [UIColor appGray];
    
    lblTextDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, self.topbarView.bounds.size.height + 5, 250, 30)];
    
    lblTextDescription.font = [UIFont systemFontOfSize:13.f];
    lblTextDescription.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblTextDescription];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, lblTextDescription.frame.origin.y + lblTextDescription.bounds.size.height + 5, [UIScreen mainScreen].bounds.size.width, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.textColor = [UIColor darkGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:textField];
    
    UIButton *btnSubmit =  [[UIButton alloc] initWithFrame:CGRectMake(0, textField.frame.origin.y + textField.bounds.size.height + 30, 400 / 2, 53 / 2)];
    btnSubmit.center = CGPointMake(self.view.center.x, btnSubmit.center.y);
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnSubmit];
}

- (void)setUp {
    lblTextDescription.text = self.txtDescription == nil ? [XXStringUtils emptyString] : self.txtDescription;
    textField.text = self.defaultValue == nil ? [XXStringUtils emptyString] : self.defaultValue;
}

- (void)viewWillAppear:(BOOL)animated {
    [textField becomeFirstResponder];
}

- (void)btnSubmitPressed:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(textView:)]) {
        [self.delegate textView:textField.text];
    }
}

- (NSString *)value {
    if(textField != nil) {
        return textField.text;
    }
    return [XXStringUtils emptyString];
}

- (void)setDefaultValue:(NSString *)defaultValue {
    _defaultValue_ = defaultValue;
    if(textField != nil) {
        if(_defaultValue_ == nil) {
            textField.text = [XXStringUtils emptyString];
        } else {
            textField.text = defaultValue;
        }
    }
}

- (void)setTxtDescription:(NSString *)txtDescription {
    _txtDescription_ = txtDescription;
    if(lblTextDescription != nil) {
        if(_txtDescription_ == nil) {
            lblTextDescription.text = [XXStringUtils emptyString];
        } else {
            lblTextDescription.text = _txtDescription_;
        }
    }
}

- (void)popupViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
