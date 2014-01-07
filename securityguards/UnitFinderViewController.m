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
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"add_unit", @"");
    
    UIButton *btnUnitFinder = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 300 / 2, 53 / 2)];
    btnUnitFinder.center = CGPointMake(self.view.center.x, btnUnitFinder.center.y);
    [btnUnitFinder setTitle:NSLocalizedString(@"auto_find", @"") forState:UIControlStateNormal];
    [btnUnitFinder setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnUnitFinder setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnUnitFinder addTarget:self action:@selector(findUnit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUnitFinder];
    
    UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 260, 58)];
    lblDescription.textAlignment = NSTextAlignmentCenter;
    lblDescription.backgroundColor = [UIColor clearColor];
    lblDescription.text = NSLocalizedString(@"unit_binding_tips", @"");
    lblDescription.center = CGPointMake(self.view.center.x, lblDescription.center.y);
    lblDescription.font = [UIFont systemFontOfSize:13.f];
    lblDescription.textColor = [UIColor lightGrayColor];
    lblDescription.numberOfLines = 2;
    [self.view addSubview:lblDescription];
}

- (void)popupViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -
#pragma mark UI Methods

- (void)findUnit {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"searching", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
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
                 [[AlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit", @"") forType:AlertViewTypeWaitting];

                 DeviceCommand *bindingUnitCommand = [CommandFactory commandForType:CommandTypeBindingUnit];
                 bindingUnitCommand.masterDeviceCode = result.unitIdentifier;
                 [[CoreService defaultService] executeDeviceCommand:bindingUnitCommand];
                  
                 DeviceCommandGetUnit *refreshUnitsCommand = (DeviceCommandGetUnit *)[CommandFactory commandForType:CommandTypeGetUnits];
                 refreshUnitsCommand.commmandNetworkMode = CommandNetworkModeInternal;
                 refreshUnitsCommand.unitServerUrl = result.unitUrl;
                 [[CoreService defaultService] executeDeviceCommand:refreshUnitsCommand];
                 
                 [[AlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit_success", @"") forType:AlertViewTypeSuccess];
                 [[AlertView currentAlertView] delayDismissAlertView];
                 
                 [[Shared shared].app.rootViewController showCenterView:NO];
                 [self popupViewController];
                 
                 return;
             }
         }
    }
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
    [[AlertView currentAlertView] delayDismissAlertView];
}

@end
