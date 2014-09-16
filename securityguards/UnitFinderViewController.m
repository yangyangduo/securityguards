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

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"add_unit", @"");

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;
    
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 22)];
    [self.view addSubview:lblLine1];
    
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 13, 220, 100)];
    lblLine1Content.text = @"请确保365智能卫士已接通电源，并自检完成(每次接通电源30-60秒后将听到“滴滴滴”三声，表示智能卫士自检已完成)";
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.numberOfLines = 4;
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 3)];
    [self.view addSubview:lblLine2];
    
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height, 220, 50)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.text = @"请确保手机与365智能卫士已连接上同一家庭WIFI网络";
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height + 9)];
    [self.view addSubview:lblLine3];
    
    UILabel *lblLine3Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height, 220, 100)];
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine3Content.textColor = [UIColor darkGrayColor];
    lblLine3Content.text  = @"请长按智能卫士主机面板上“风速”键3秒,并在2分钟内点击“开始绑定”按钮,完成手机与智能卫士的绑定操作";
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.numberOfLines = 4;
    lblLine3Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine3Content];
    
    UIButton *btnRebind = [[UIButton alloc] initWithFrame:CGRectMake(0, lblLine3Content.frame.origin.y + lblLine3Content.frame.size.height + 20, 500 / 2, 66 / 2)];
    btnRebind.center = CGPointMake(self.view.center.x, btnRebind.center.y);
    [btnRebind setTitle:@"开始绑定" forState:UIControlStateNormal];
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
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"cancelling", @"") forType:AlertViewTypeWaitting showCancellButton:NO];
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
