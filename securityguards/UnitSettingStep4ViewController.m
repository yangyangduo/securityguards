//
//  UnitSettingStep4ViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep4ViewController.h"
#import "UnitSettingStep5ViewController.h"
#import "TipsLabel.h"
#import "Shared.h"
#define TOPBAR_HEIGHT self.topbarView.frame.size.height

@interface UnitSettingStep4ViewController ()

@end

@implementation UnitSettingStep4ViewController

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
    self.topbarView.title = NSLocalizedString(@"step4_title", @"");
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 20+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine1.frame.origin.y, 220, 25)];
    lblLine1Content.text = NSLocalizedString(@"step4_line1_linking", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(60, lblLine1.frame.origin.y+lblLine1.frame.size.height)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine2.frame.origin.y, 200, 25)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = NSLocalizedString(@"step4_line2", @"");
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblWIFIName = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine2Content.frame.origin.y+lblLine2Content.frame.size.height+5, 200, 50)];
    lblWIFIName.text = [Shared shared].currentWIFIName;
    lblWIFIName.textColor = [UIColor appBlue];
    [self.view addSubview:lblWIFIName];
    
    UITextField *txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, lblWIFIName.frame.size.height+lblWIFIName.frame.origin.y+5, 250, 53/2)];
    txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
    txtPassword.placeholder = NSLocalizedString(@"wifi_password",@"");
    txtPassword.textColor = [UIColor darkGrayColor];
    txtPassword.background = [UIImage imageNamed:@"light_gray_textbox.png"];
    txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPassword.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtPassword.font = [UIFont systemFontOfSize:14.f];
    txtPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    txtPassword.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:txtPassword];
    
    UIButton *btnSendSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y+txtPassword.frame.size.height+10, 502/2, 56/2)];
    btnSendSettings.center = CGPointMake(self.view.center.x, btnSendSettings.center.y);
    [btnSendSettings setTitle:NSLocalizedString(@"send_settings", @"") forState:UIControlStateNormal];
    [btnSendSettings setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnSendSettings setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnSendSettings setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnSendSettings addTarget:self action:@selector(btnSendSettingsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSendSettings];

}

- (void)btnSendSettingsPressed:(UIButton *)sender{
    [self.navigationController pushViewController:[[UnitSettingStep5ViewController alloc] init] animated:YES];
}

#pragma mark - 
#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
