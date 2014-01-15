//
//  UnitSettingStep1ViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep1ViewController.h"
#import "TipsLabel.h"
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
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 40+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(70, lblLine1.frame.origin.y, 200, 50)];
    lblLine1Content.text = NSLocalizedString(@"step1_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    [self.view addSubview:lblLine1Content];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
