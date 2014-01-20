//
//  UnitSettingStep3ViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep3ViewController.h"
#import "UnitSettingStep4ViewController.h"
#import "TipsLabel.h"
#define TOPBAR_HEIGHT self.topbarView.frame.size.height

@interface UnitSettingStep3ViewController ()

@end

@implementation UnitSettingStep3ViewController

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
    self.topbarView.title = NSLocalizedString(@"step3_title", @"");
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 20+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(70, lblLine1.frame.origin.y, 200, 75)];
    lblLine1Content.text = NSLocalizedString(@"step3_line1", @"");
    lblLine1Content.numberOfLines = 3;
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblHotPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, lblLine1Content.frame.origin.y+lblLine1Content.frame.size.height, 200, 30)];
    lblHotPoint.center = CGPointMake(self.view.center.x, lblHotPoint.center.y);
    lblHotPoint.text = @"365jws.hentre.com";
    lblHotPoint.textColor = [UIColor appBlue];
    lblHotPoint.backgroundColor = [UIColor clearColor];
    lblHotPoint.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:lblHotPoint];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, lblHotPoint.frame.origin.y+lblHotPoint.frame.size.height, 200, 30)];
    lblTips.center = CGPointMake(self.view.center.x, lblTips.center.y);
    lblTips.text = NSLocalizedString(@"step3_tips", @"");
    [self.view addSubview:lblTips];
    
//    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y+imgTips.frame.size.height+10, 500/2, 53/2)];
//    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
//    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
//    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
//    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
//    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
//    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnNextStep];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
