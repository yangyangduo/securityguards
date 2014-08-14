//
//  UnitSettingStep4ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep4ViewController.h"
#import "UnitSettingStep5ViewController.h"
#import "TipsLabel.h"
#import "SMNetworkTool.h"
#import "Shared.h"

@interface UnitSettingStep4ViewController () {
//    UILabel *lblLine1Content;
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
    self.topbarView.title = @"第四步:配置家卫士";

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 14)];
    [self.view addSubview:lblLine1];

//    lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 15, 220, 25)];
//    lblLine1Content.text = NSLocalizedString(@"step4_line1_linking", @"");
//    lblLine1Content.textColor = [UIColor darkGrayColor];
//    lblLine1Content.backgroundColor = [UIColor clearColor];
//    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
//    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 15)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:
            CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 15, 220, 25)];
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = @"配置家卫士WIFI网络名称为:";
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine2Content];
    
    lblWIFIName = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfTipsLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height + 8, 220, 25)];
    lblWIFIName.font = [UIFont systemFontOfSize:15.f];
    lblWIFIName.textColor = [UIColor appBlue];
    [self.view addSubview:lblWIFIName];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, lblWIFIName.frame.size.height + lblWIFIName.frame.origin.y + 10, 250, 58 / 2)];
    txtPassword.center = CGPointMake(self.view.center.x, txtPassword.center.y);
    txtPassword.placeholder = @"WIFI密码";
    txtPassword.textColor = [UIColor darkGrayColor];
    txtPassword.background = [UIImage imageNamed:@"light_gray_textbox"];
    txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPassword.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtPassword.keyboardType = UIKeyboardTypeASCIICapable;
    txtPassword.font = [UIFont systemFontOfSize:13.f];
    txtPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    txtPassword.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:txtPassword];
    
    btnSendSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y + txtPassword.frame.size.height + 15, 500 / 2, 66 / 2)];
    btnSendSettings.center = CGPointMake(self.view.center.x, btnSendSettings.center.y);
    [btnSendSettings setTitle:@"发送配置" forState:UIControlStateNormal];
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
        [[XXAlertView currentAlertView] setMessage:@"请连接家卫士WIFI" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }

    NSString *localIp = [SMNetworkTool getLocalIp];
    if(![XXStringUtils isBlank:localIp]) {
        NSArray *components = [localIp componentsSeparatedByString:@"."];
        NSString *url = [NSString stringWithFormat:@"http://%@.%@.%@.1:8777/wifi/connections", [components objectAtIndex:0], [components objectAtIndex:1], [components objectAtIndex:2]];

        /*
        NSString *stringBody = [NSString stringWithFormat:@"wifiSSID=%@&wifiPwd=%@", [Shared shared].lastedContectionWifiName, [XXStringUtils trim:txtPassword.text]];
        */
        
        NSDictionary *postJson = @{
                                    @"ssid" : [Shared shared].lastedContectionWifiName,
                                    @"preSharedKey" : [XXStringUtils trim:txtPassword.text],
                                    @"ipAssignment" : @"DHCP"
                                   };
        
        NSData *jsonData = [JsonUtils createJsonDataFromDictionary:postJson];

        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        RestClient *client = [[RestClient alloc] init];
        [client postForUrl:url acceptType:@"application/json" contentType:@"application/json" body:jsonData success:@selector(sendPasswordSuccess:) error:@selector(sendPasswordFailed:) for:self callback:nil];
    }
}

- (void)sendPasswordSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        [self.navigationController pushViewController:[[UnitSettingStep5ViewController alloc] init] animated:YES];
        return;
    }
    [self sendPasswordFailed:resp];
}

- (void)sendPasswordFailed:(RestResponse *)resp {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"send_failed", @"") forType:AlertViewTypeFailed];
    [[XXAlertView currentAlertView] delayDismissAlertView];
}

#pragma mark - 
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [txtPassword becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [self detectionFamilyGuardsWifiExists];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    [self setWifiNameForLabel:[Shared shared].lastedContectionWifiName];
    NSString *wifiName = [SMNetworkTool ssidForCurrentWifi];
    if(![XXStringUtils isBlank:wifiName] && ([FamilyGuardsHotSpotName isEqualToString:wifiName]
                                             || [DefaultFamilyGuardsHotSpotName isEqualToString:wifiName])) {
        [self enableContinue];
        return YES;
    } else {
        [self disableContinue];
        return NO;
    }
}

- (void)enableContinue {
}

- (void)disableContinue {
}

@end





