//
//  AddUnitViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AddUnitViewController.h"
#import "UnitSettingStep1ViewController.h"
#import "UnitFinderViewController.h"

@interface AddUnitViewController ()

@end

@implementation AddUnitViewController{

}

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

    CGFloat widthOfButton = 300 / 2;
    CGFloat heightOfButton = 306 / 2;

    CGFloat heightOfWhiteSpace = [UIScreen mainScreen].bounds.size.height - self.topbarView.bounds.size.height;
    CGFloat buttonVSpace = (heightOfWhiteSpace - 2 * heightOfButton) / 3.f;

    UIButton *btnUnitSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height + buttonVSpace, widthOfButton, heightOfButton)];
    btnUnitSettings.center = CGPointMake(self.view.center.x, btnUnitSettings.center.y);
    [btnUnitSettings setBackgroundImage:[UIImage imageNamed:@"button_setting"] forState:UIControlStateNormal];
    [btnUnitSettings setBackgroundImage:[UIImage imageNamed:@"button_highlighted_setting"] forState:UIControlStateHighlighted];
    [btnUnitSettings addTarget:self action:@selector(btnUnitSettingsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUnitSettings];
    
    UIButton *btnUnitBinding = [[UIButton alloc] initWithFrame:CGRectMake(0, btnUnitSettings.frame.size.height + btnUnitSettings.frame.origin.y + buttonVSpace, widthOfButton, heightOfButton)];
    btnUnitBinding.center = CGPointMake(self.view.center.x, btnUnitBinding.center.y);
    [btnUnitBinding setBackgroundImage:[UIImage imageNamed:@"button_bind"] forState:UIControlStateNormal];
    [btnUnitBinding setBackgroundImage:[UIImage imageNamed:@"button_highlighted_bind"] forState:UIControlStateHighlighted];
    [btnUnitBinding addTarget:self action:@selector(btnUnitBindingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUnitBinding];
}

- (void)btnUnitSettingsPressed:(id)sender {
    [self.navigationController pushViewController:[[UnitSettingStep1ViewController alloc] init] animated:YES];
}

- (void)btnUnitBindingPressed:(id)sender {
    [self.navigationController pushViewController:[[UnitFinderViewController alloc] init] animated:YES];
}

- (void)popupViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
