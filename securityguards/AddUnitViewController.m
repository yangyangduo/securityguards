//
//  AddUnitViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AddUnitViewController.h"
#define BTN_WIDTH 300/2
#define BTN_HEIGHT 306/2

@interface AddUnitViewController ()

@end

@implementation AddUnitViewController

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
    self.topbarView.title = NSLocalizedString(@"add_unit", @"");
    UIButton *btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height+100, BTN_WIDTH, BTN_HEIGHT)];
    btnSetting.center = CGPointMake(self.view.center.x, btnSetting.center.y);
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"button_setting.png"] forState:UIControlStateNormal];
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"button_highlighted_setting.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnSetting];
    
    UIButton *btnBind = [[UIButton alloc] initWithFrame:CGRectMake(0, btnSetting.frame.size.height+btnSetting.frame.origin.y+20, BTN_WIDTH, BTN_HEIGHT)];
    btnBind.center = CGPointMake(self.view.center.x, btnBind.center.y);
    [btnBind setBackgroundImage:[UIImage imageNamed:@"button_bind.png"] forState:UIControlStateNormal];
    [btnBind setBackgroundImage:[UIImage imageNamed:@"button_highlighted_bind.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnBind];
}

- (void)popupViewController{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
