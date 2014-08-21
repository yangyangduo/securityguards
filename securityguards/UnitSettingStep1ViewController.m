//
//  UnitSettingStep1ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep1ViewController.h"
#import "UnitSettingStep2ViewController.h"
#import "TipsLabel.h"
#import "SMNetworkTool.h"
#import "Shared.h"

#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

@interface UnitSettingStep1ViewController ()

@end

@implementation UnitSettingStep1ViewController

- (void)initUI{
    [super initUI];
    self.topbarView.title = @"第一步:设置前准备";

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 13)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 10, 220, 50)];
    lblLine1Content.text = @"请确保家庭中有一个已联网的无线路由器";
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.numberOfLines = 2;
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];

    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 3)];
    [self.view addSubview:lblLine2];

    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height, 220, 50)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.text = @"请将手机以WIFI方式接入该家庭路由器";
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height + 5)];
    [self.view addSubview:lblLine3];
    
    UILabel *lblLine3Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height, 220, 50)];
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine3Content.textColor = [UIColor darkGrayColor];
    lblLine3Content.text  = @"请将摄像头用网线连接到路由器(配置成功后,可拔掉网线)";
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.numberOfLines = 2;
    lblLine3Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine3Content];
    
    UILabel *lblLine4 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine3Content.frame.origin.y + lblLine3Content.frame.size.height + 12)];
    [self.view addSubview:lblLine4];
    
    UILabel *lblLine4Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine3Content.frame.origin.y + lblLine3Content.frame.size.height + 4, 220, 75)];
    lblLine4Content.numberOfLines = 3;
    lblLine4Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine4Content.textColor = [UIColor darkGrayColor];
    lblLine4Content.text  = @"请确保手机、摄像头以及即将接入网络的家卫士都在使用同一网络";
    lblLine4Content.backgroundColor = [UIColor clearColor];
    lblLine4Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine4Content];
    
    UIImageView *imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLine4Content.frame.origin.y + lblLine4Content.frame.size.height + 5, 431 / 2, 196 / 2)];
    imgTips.image = [UIImage imageNamed:@"image_setting_step1"];
    imgTips.center = CGPointMake(self.view.center.x, imgTips.center.y);
    [self.view addSubview:imgTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y + imgTips.frame.size.height + 18, 500 / 2, 66 / 2)];
    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];
}

- (void)btnNextStepPressed:(UIButton *)sender{
    NSString *currentWifiName = [SMNetworkTool ssidForCurrentWifi];
    [Shared shared].lastedContectionWifiName = currentWifiName;
    if(![XXStringUtils isBlank:currentWifiName]) {
        if([DefaultFamilyGuardsHotSpotName isEqualToString:currentWifiName]) {
            [[XXAlertView currentAlertView] setMessage:@"WIFI选择错误" forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            return;
        }
        [self.navigationController pushViewController:[[UnitSettingStep2ViewController alloc] init] animated:YES];
    } else {
        [[XXAlertView currentAlertView] setMessage:@"请先连接WIFI" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    }
}

@end
