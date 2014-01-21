//
//  UnitSettingStep5ViewController.m
//  securityguards
//
//  Created by hadoop user account on 17/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep5ViewController.h"
#import "TipsLabel.h"
#import "Shared.h"
#define TOPBAR_HEIGHT self.topbarView.frame.size.height

@interface UnitSettingStep5ViewController ()

@end

@implementation UnitSettingStep5ViewController

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
    self.topbarView.title = NSLocalizedString(@"step5_title", @"");
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 20+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(70, lblLine1.frame.origin.y, 220, 25)];
    lblLine1Content.text = NSLocalizedString(@"step5_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(60, lblLine1.frame.origin.y+lblLine1.frame.size.height+5)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(70, lblLine2.frame.origin.y-5, 200, 50)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = NSLocalizedString(@"step5_line2", @"");
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblWIFIName = [[UILabel alloc] initWithFrame:CGRectMake(70, lblLine2Content.frame.origin.y+lblLine2Content.frame.size.height+5, 200, 50)];
    lblWIFIName.text = [Shared shared].currentWIFIName;
    lblWIFIName.textColor = [UIColor appBlue];
    [self.view addSubview:lblWIFIName];
    
    
    UIButton *btnReset = [[UIButton alloc] initWithFrame:CGRectMake(0, lblWIFIName.frame.origin.y+lblWIFIName.frame.size.height+10, 500/2, 53/2)];
    btnReset.center = CGPointMake(self.view.center.x, btnReset.center.y);
    [btnReset setTitle:NSLocalizedString(@"reset", @"") forState:UIControlStateNormal];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnReset addTarget:self action:@selector(btnResetPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReset];

}

- (void)btnResetPressed:(UIButton *) sender{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
