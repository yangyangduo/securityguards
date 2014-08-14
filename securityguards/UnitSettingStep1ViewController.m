//
//  UnitSettingStep1ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep1ViewController.h"
#import "TipsLabel.h"
#import "UnitSettingStep2ViewController.h"
#import "SMNetworkTool.h"
#import "Shared.h"

#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

@interface UnitSettingStep1ViewController ()

@end

@implementation UnitSettingStep1ViewController

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
    self.topbarView.title = @"第一步:设置前准备";

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 13)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 10, 220, 50)];
    lblLine1Content.text = @"请将摄像头用网线连接到路由器。";
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.numberOfLines = 2;
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];


    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 3)];
    [self.view addSubview:lblLine2];

    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height, 220, 50)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = @"将手机WIFI打开并连接到同一个路由器的WIFI热点上。";
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height + 7)];
    [self.view addSubview:lblLine3];
    UILabel *lblLine3Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height, 220, 75)];
    lblLine3Content.numberOfLines = 3;
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine3Content.textColor = [UIColor darkGrayColor];
    lblLine3Content.text  = @"请确保手机、摄像头以及即将接入网络的家卫士都在使用同一网络。";
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine3Content];
    
    UIImageView *imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLine3Content.frame.origin.y + lblLine3Content.frame.size.height + 5, 431 / 2, 196 / 2)];
    imgTips.image = [UIImage imageNamed:@"image_setting_step1.png"];
    imgTips.center = CGPointMake(self.view.center.x, imgTips.center.y);
    [self.view addSubview:imgTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y + imgTips.frame.size.height + 15, 500 / 2, 66 / 2)];
    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];
}

- (void)btnNextStepPressed:(UIButton *)sender{
        [Shared shared].lastedContectionWifiName = [SMNetworkTool ssidForCurrentWifi];
        if(![XXStringUtils isBlank:[Shared shared].lastedContectionWifiName]) {
            [self.navigationController pushViewController:[[UnitSettingStep2ViewController alloc] init] animated:YES];
        } else {
            [[XXAlertView currentAlertView] setMessage:@"请先连接WIFI" forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
