//
//  UnitFinderViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitFinderViewController.h"

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
    [[AlertView currentAlertView] setMessage:@"searching" forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:YES];
    UnitFinder *finder = [[UnitFinder alloc] init];
    finder.delegate = self;
    [finder findUnit];
}

#pragma mark -
#pragma mark Unit Finder Delegate

- (void)unitFinderOnResult:(UnitFinderResult *)result {
    if(result.resultType == UnitFinderResultTypeFailed) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
    } else if(result.resultType == UnitFinderResultTypeSuccess) {
        
    } else {
#ifdef DEBUG
        NSLog(@"[UNIT FINDER VIEW CONTROLLER] Unknow result type.");
#endif
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

@end
