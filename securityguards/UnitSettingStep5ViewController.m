//
//  UnitSettingStep5ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 17/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep5ViewController.h"
#import "UnitSettingStep1ViewController.h"
#import "TipsLabel.h"
#import "Shared.h"
#import "SMNetworkTool.h"

@interface UnitSettingStep5ViewController ()

@end

@implementation UnitSettingStep5ViewController {
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)initUI{
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"step5_title", @"");

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 9)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:
            CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 10, 220, 25)];
    lblLine1Content.text = NSLocalizedString(@"step5_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1.frame.origin.y+lblLine1.frame.size.height + 4)];
    [self.view addSubview:lblLine2];
    UILabel *lblLine2Content = [[UILabel alloc] initWithFrame:
            CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height + 5, 220, 50)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.text = NSLocalizedString(@"step5_line2", @"");
    lblLine2Content.textColor = [UIColor darkGrayColor];
    lblLine2Content.backgroundColor = [UIColor clearColor];
    lblLine2Content.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblWIFIName = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfTipsLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height + 6, 220, 25)];
    lblWIFIName.text = [Shared shared].lastedContectionWifiName;
    lblWIFIName.textColor = [UIColor appBlue];
    [self.view addSubview:lblWIFIName];

    UIButton *btnStartBinding = [[UIButton alloc] initWithFrame:CGRectMake(0, lblWIFIName.frame.origin.y + lblWIFIName.frame.size.height + 15, 500 / 2, 66 / 2)];
    btnStartBinding.center = CGPointMake(self.view.center.x, btnStartBinding.center.y);
    [btnStartBinding setTitle:NSLocalizedString(@"start_binding", @"") forState:UIControlStateNormal];
    [btnStartBinding setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnStartBinding setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnStartBinding setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnStartBinding addTarget:self action:@selector(btnStartBindingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStartBinding];
    
    UIButton *btnReset = [[UIButton alloc] initWithFrame:CGRectMake(0, btnStartBinding.frame.origin.y + btnStartBinding.bounds.size.height + 15, 500 / 2, 66 / 2)];
    btnReset.center = CGPointMake(self.view.center.x, btnReset.center.y);
    [btnReset setTitle:NSLocalizedString(@"reset", @"") forState:UIControlStateNormal];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnReset setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnReset addTarget:self action:@selector(btnResetPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReset];
}

- (void)btnResetPressed:(UIButton *)sender {
    [Shared shared].lastedContectionWifiName = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[UnitSettingStep1ViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)btnStartBindingPressed:(UIButton *)sender {
    if(![[SMNetworkTool ssidForCurrentWifi] isEqualToString:[Shared shared].lastedContectionWifiName]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"change_wifi_to_lasted", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    
    UnitFinder *finder = [[UnitFinder alloc] init];
    finder.delegate = self;
    [finder startFinding];
    isFinding = YES;
    cancelledByUser = NO;
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO cancelledBlock:^{
        if(!cancelledByUser && isFinding) {
            cancelledByUser = YES;
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"cancelling", @"") forType:AlertViewTypeWaitting];
            [finder reset];
        }
    }];
}


#pragma mark -
#pragma mark Unit find delegate

- (void)unitFinderOnResult:(UnitFinderResult *)result {
    if(UnitFinderResultTypeSuccess == result.resultType) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"binding_unit_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        NSLog(@"!!!!!!!!!!!!!!!!!!!!! ----   unit finder success ..... %@  -- %@  ", result.unitIdentifier, result.unitUrl);
    } else {
        if(!cancelledByUser) {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
        } else {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"success_cancelled", @"") forType:AlertViewTypeSuccess];
        }
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        isFinding = NO;
        cancelledByUser = NO;
        
        NSLog(@"!!!!!!!!!!!!!!!!!!!!! ------   unit finder failed  .... reason is  %@", result.failedReason);
    }
}

@end
