//
//  UnitFinderViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitFinderViewController.h"
#import "UnitManager.h"
#import "Shared.h"
#import "TipsLabel.h"
#define TOPBAR_HEIGHT self.topbarView.frame.size.height


@interface UnitFinderViewController ()

@end

@implementation UnitFinderViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
//    [super initUI];
//    
//    self.topbarView.title = NSLocalizedString(@"add_unit", @"");
//    
//    UIButton *btnUnitFinder = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 300 / 2, 53 / 2)];
//    btnUnitFinder.center = CGPointMake(self.view.center.x, btnUnitFinder.center.y);
//    [btnUnitFinder setTitle:NSLocalizedString(@"auto_find", @"") forState:UIControlStateNormal];
//    [btnUnitFinder setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
//    [btnUnitFinder setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
//    [btnUnitFinder addTarget:self action:@selector(findUnit) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnUnitFinder];
//    
//    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 260, 58)];
//    lblDescription.textAlignment = NSTextAlignmentCenter;
//    lblDescription.backgroundColor = [UIColor clearColor];
//    lblDescription.text = NSLocalizedString(@"unit_binding_tips", @"");
//    lblDescription.center = CGPointMake(self.view.center.x, lblDescription.center.y);
//    lblDescription.font = [UIFont systemFontOfSize:13.f];
//    lblDescription.textColor = [UIColor lightGrayColor];
//    lblDescription.numberOfLines = 2;
//    [self.view addSubview:lblDescription];
    
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"add_unit", @"");
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 20+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine1.frame.origin.y, 200, 40)];
    lblLine1Content.text = NSLocalizedString(@"unit_finder_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.numberOfLines = 2;
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(60, lblLine1.frame.origin.y+lblLine1.frame.size.height+10)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine2.frame.origin.y, 220, 25)];
    lblLine2Content.text = NSLocalizedString(@"unit_finder_line2", @"");
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:lblLine2Content];
    
    
    UIButton *btnRebind = [[UIButton alloc] initWithFrame:CGRectMake(0, lblLine2Content.frame.origin.y+lblLine2Content.frame.size.height+10, 500/2, 53/2)];
    btnRebind.center = CGPointMake(self.view.center.x, btnRebind.center.y);
    [btnRebind setTitle:NSLocalizedString(@"rebind", @"") forState:UIControlStateNormal];
    [btnRebind setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnRebind setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnRebind setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnRebind addTarget:self action:@selector(btnRebindPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRebind];

}

- (void)popupViewController {
//    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnRebindPressed:(UIButton *)sender{
    
}

#pragma mark -
#pragma mark UI Methods

- (void)findUnit {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"searching", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    UnitFinder *finder = [[UnitFinder alloc] init];
    finder.delegate = self;
    [finder findUnit];
}

#pragma mark -
#pragma mark Unit Finder Delegate

- (void)unitFinderOnResult:(UnitFinderResult *)result {
     if(result.resultType == UnitFinderResultTypeSuccess) {
         if(![XXStringUtils isBlank:result.unitIdentifier]) {
             if([[UnitManager defaultManager] findUnitByIdentifier:result.unitIdentifier] == nil) {
                 [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit", @"") forType:AlertViewTypeWaitting];

                 DeviceCommand *bindingUnitCommand = [CommandFactory commandForType:CommandTypeBindingUnit];
                 bindingUnitCommand.masterDeviceCode = result.unitIdentifier;
                 [[CoreService defaultService] executeDeviceCommand:bindingUnitCommand];
                  
                 DeviceCommandGetUnit *refreshUnitsCommand = (DeviceCommandGetUnit *)[CommandFactory commandForType:CommandTypeGetUnits];
                 refreshUnitsCommand.commandNetworkMode = CommandNetworkModeInternal;
                 refreshUnitsCommand.unitServerUrl = result.unitUrl;
                 [[CoreService defaultService] executeDeviceCommand:refreshUnitsCommand];
                 
                 [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit_success", @"") forType:AlertViewTypeSuccess];
                 [[XXAlertView currentAlertView] delayDismissAlertView];
                 
                 [[Shared shared].app.rootViewController showCenterView:NO];
                 [self popupViewController];
                 
                 return;
             }
         }
    }
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
    [[XXAlertView currentAlertView] delayDismissAlertView];
}

@end
