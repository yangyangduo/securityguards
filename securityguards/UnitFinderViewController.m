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

@interface UnitFinderViewController ()

@end

@implementation UnitFinderViewController {
    
    
    BOOL isFinding;
    BOOL cancelledByUser;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
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

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(55, self.topbarView.frame.size.height + 25)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(65, self.topbarView.frame.size.height + 23, 220, 50)];
    lblLine1Content.text = NSLocalizedString(@"unit_finder_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.numberOfLines = 2;
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];
    
    UIButton *btnRebind = [[UIButton alloc] initWithFrame:CGRectMake(0, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 20, 500 / 2, 66 / 2)];
    btnRebind.center = CGPointMake(self.view.center.x, btnRebind.center.y);
    [btnRebind setTitle:NSLocalizedString(@"start_binding", @"") forState:UIControlStateNormal];
    [btnRebind setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnRebind setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnRebind setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnRebind addTarget:self action:@selector(btnRebindPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRebind];
}

- (void)popupViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnRebindPressed:(UIButton *)sender{
    [self findUnit];
}

#pragma mark -
#pragma mark UI Methods

- (void)findUnit {
    if(isFinding) return;
    isFinding = YES;
    cancelledByUser = NO;
    
    UnitFinder *finder = [[UnitFinder alloc] init];
    finder.delegate = self;
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO cancelledBlock:^{
        if(!cancelledByUser && isFinding) {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"cancelling", @"") forType:AlertViewTypeWaitting];
            cancelledByUser = YES;
            [finder reset];
        }
    }];
    [finder startFinding];
}

#pragma mark -
#pragma mark Unit Finder Delegate

- (void)unitFinderOnResult:(UnitFinderResult *)result {
     if(result.resultType == UnitFinderResultTypeSuccess) {
         if(![XXStringUtils isBlank:result.unitIdentifier]) {
             if([[UnitManager defaultManager] findUnitByIdentifier:result.unitIdentifier] == nil) {
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
    
    if(!cancelledByUser) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"success_cancelled", @"") forType:AlertViewTypeSuccess];
    }
    [[XXAlertView currentAlertView] delayDismissAlertView];
    
    isFinding = NO;
    cancelledByUser = NO;
}

@end
