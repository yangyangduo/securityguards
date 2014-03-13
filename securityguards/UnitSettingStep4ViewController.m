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
#import "SMNetworkTool.h"

@interface UnitSettingStep4ViewController () {
    UILabel *lblWIFIName;
    UITextField *txtPassword;
    UIButton *btnSendSettings;
}

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

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 14)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 15, 220, 25)];
    lblLine1Content.text = NSLocalizedString(@"step4_line1_linking", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 8)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:
            CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 10, 220, 25)];
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = NSLocalizedString(@"step4_line2", @"");
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine2Content];
    
    lblWIFIName = [[UILabel alloc] initWithFrame:CGRectMake(0, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height + 25, 220, 25)];
    lblWIFIName.center = CGPointMake(self.view.center.x, lblWIFIName.center.y);
    lblWIFIName.textAlignment = NSTextAlignmentCenter;
    lblWIFIName.font = [UIFont systemFontOfSize:16.f];
    lblWIFIName.textColor = [UIColor appBlue];
    [self.view addSubview:lblWIFIName];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, lblWIFIName.frame.size.height + lblWIFIName.frame.origin.y + 25, 250, 58 / 2)];
    txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
    txtPassword.placeholder = NSLocalizedString(@"wifi_password",@"");
    txtPassword.textColor = [UIColor darkGrayColor];
    txtPassword.background = [UIImage imageNamed:@"light_gray_textbox"];
    txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPassword.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtPassword.font = [UIFont systemFontOfSize:13.f];
    txtPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    txtPassword.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:txtPassword];
    
    btnSendSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y + txtPassword.frame.size.height + 15, 500 / 2, 66 / 2)];
    btnSendSettings.center = CGPointMake(self.view.center.x, btnSendSettings.center.y);
    [btnSendSettings setTitle:NSLocalizedString(@"send_settings", @"") forState:UIControlStateNormal];
    [btnSendSettings setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnSendSettings setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnSendSettings setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnSendSettings addTarget:self action:@selector(btnSendSettingsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSendSettings];

    [self setWifiNameForLabel:nil];
    [self disableContinue];
}

- (void)btnSendSettingsPressed:(UIButton *)sender {
    if(![self detectionFamilyGuardsWifiExists]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }

    // send wifi and password ...
    [self.navigationController pushViewController:[[UnitSettingStep5ViewController alloc] init] animated:YES];
}

#pragma mark - 
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [Shared shared].app.wifiConfigViewController = self;
    [self detectionFamilyGuardsWifiExists];
}

- (void)viewWillDisappear:(BOOL)animated {
    [Shared shared].app.wifiConfigViewController = nil;
}

- (void)setWifiNameForLabel:(NSString *)wifiName {
    if(lblWIFIName == nil) return;
    if([XXStringUtils isBlank:wifiName]) {
        lblWIFIName.text = NSLocalizedString(@"un_connectted_wifi", @"");
    } else {
        lblWIFIName.text = wifiName;
    }
}

- (BOOL)detectionFamilyGuardsWifiExists {
    NSString *wifiName = [SMNetworkTool ssidForCurrentWifi];
    [self setWifiNameForLabel:wifiName];
    if(![XXStringUtils isBlank:wifiName] && [@"Hentre-ROS1" isEqualToString:wifiName]) {
        [self enableContinue];
        return YES;
    } else {
        [self disableContinue];
        return NO;
    }
}

- (void)enableContinue {
    txtPassword.enabled = YES;
    btnSendSettings.enabled = YES;
}

- (void)disableContinue {
    txtPassword.enabled = NO;
    btnSendSettings.enabled = NO;
}

@end





