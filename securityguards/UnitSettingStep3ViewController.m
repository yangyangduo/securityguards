//
//  UnitSettingStep3ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep3ViewController.h"
#import "UnitSettingStep4ViewController.h"
#import "TipsLabel.h"

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

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 17)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 10, 220, 75)];
    lblLine1Content.text = NSLocalizedString(@"step3_line1", @"");
    lblLine1Content.numberOfLines = 3;
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblHotPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height, 220, 30)];
    lblHotPoint.center = CGPointMake(self.view.center.x, lblHotPoint.center.y);
    lblHotPoint.textAlignment = NSTextAlignmentCenter;
    lblHotPoint.text = FamilyGuardsHotSpotName;
    lblHotPoint.textColor = [UIColor appBlue];
    lblHotPoint.backgroundColor = [UIColor clearColor];
    lblHotPoint.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:lblHotPoint];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, lblHotPoint.frame.origin.y + lblHotPoint.frame.size.height, 200, 30)];
    lblTips.center = CGPointMake(self.view.center.x, lblTips.center.y);
    lblTips.text = NSLocalizedString(@"step3_tips", @"");
    lblTips.font = [UIFont systemFontOfSize:15.f];
    lblTips.textColor = [UIColor lightGrayColor];
    [self.view addSubview:lblTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTips.frame.origin.y+lblTips.frame.size.height + 10, 500 / 2, 66 / 2)];
    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];
    

}

- (void)btnNextStepPressed:(UIButton *)sender{
    [self.navigationController pushViewController:[[UnitSettingStep4ViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
