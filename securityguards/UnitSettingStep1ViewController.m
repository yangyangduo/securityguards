//
//  UnitSettingStep1ViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep1ViewController.h"
#import "TipsLabel.h"
#import "UnitSettingStep2ViewController.h"
#import "SMNetworkTool.h"
#import "Shared.h"
#define TOPBAR_HEIGHT self.topbarView.frame.size.height
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
    self.topbarView.title = NSLocalizedString(@"step1_title", @"");
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 20+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine1.frame.origin.y, 220, 25)];
    lblLine1Content.text = NSLocalizedString(@"step1_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(60, lblLine1.frame.origin.y+lblLine1.frame.size.height+5)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine2.frame.origin.y, 200, 40)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = NSLocalizedString(@"step1_line2", @"");
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(60,lblLine2.frame.origin.y+lblLine2.frame.size.height+15)];
    [self.view addSubview:lblLine3];
    UILabel *lblLine3Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine3.frame.origin.y-5, 200, 50)];
    lblLine3Content.numberOfLines = 2;
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine3Content.textColor = [UIColor darkGrayColor];
    lblLine3Content.text  = NSLocalizedString(@"step1_line3", @"");
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:lblLine3Content];
    
    UIImageView *imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLine3Content.frame.origin.y+lblLine3Content.frame.size.height +5, 431/2, 196/2)];
    imgTips.image = [UIImage imageNamed:@"image_setting_step1.png"];
    imgTips.center = CGPointMake(self.view.center.x, imgTips.center.y);
    [self.view addSubview:imgTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y+imgTips.frame.size.height+10, 500/2, 53/2)];
    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];
    
    
    
    
}

- (void)btnNextStepPressed:(UIButton *)sender{
    [Shared shared].currentWIFIName = [SMNetworkTool ssidForCurrentWifi];
//    if ([Shared shared].currentWIFIName !=nil && ![[Shared shared].currentWIFIName isEqualToString:@""]) {
        [self.navigationController pushViewController:[[UnitSettingStep2ViewController alloc] init] animated:YES];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
