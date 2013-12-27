//
//  MainViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalViewController.h"
#import "LoginViewController.h"
#import "XXStringUtils.h"
#import "GlobalSettings.h"
#import "SensorDisplayView.h"
#import "UnitControlPanel.h"
#import "UIColor+MoreColor.h"

@interface PortalViewController ()

@end

@implementation PortalViewController {
    UIScrollView *scrollView;
    
    UILabel *lblHealthIndex;
    UILabel *lblHealthIndexGreatThan;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.topbarView.title = @"Test";
    
    BOOL hasLogin = ![[XXStringUtils emptyString] isEqualToString:[GlobalSettings defaultSettings].secretKey];
    if(hasLogin) {
        
    } else {
        UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        loginNavController.navigationBarHidden = YES;
        [self presentViewController:loginNavController animated:NO completion:^{}];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [super initUI];
    
    /*
     * Create right button to show units list     
     */
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 8 - 55 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? (20 + 8) : 8, 55 / 2, 55 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_drawer_right"] forState:UIControlStateNormal];
    [self.topbarView addSubview:btnRight];
    
    /*
     * Create voice button view
     */
    UIView *voiceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 42, [UIScreen mainScreen].bounds.size.width, 42)];
    voiceBackgroundView.backgroundColor = [UIColor appGray];
    
    UIButton *btnVoice = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 556 / 2, 64 / 2)];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_gray"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_blue"] forState:UIControlStateHighlighted];
    [btnVoice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnVoice setTitle:NSLocalizedString(@"btn_voice_title", @"") forState:UIControlStateNormal];
    btnVoice.center = CGPointMake(voiceBackgroundView.center.x, btnVoice.center.y);
    
    [voiceBackgroundView addSubview:btnVoice];
    [self.view addSubview:voiceBackgroundView];
    
    /*
     * Create scroll view
     */
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - voiceBackgroundView.bounds.size.height)];
    scrollView.backgroundColor = [UIColor appGray];
    [self.view addSubview:scrollView];
    
    /*
     * Create heathIndex view
     */
    UIImageView *imgHeathIndex = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    imgHeathIndex.image = [UIImage imageNamed:@"bg_health_index"];
    [scrollView addSubview:imgHeathIndex];
    
    lblHealthIndex = [[UILabel alloc] initWithFrame:CGRectMake(44, 34, 45, 50)];
    lblHealthIndex.backgroundColor = [UIColor clearColor];
    lblHealthIndex.text = @"99";
    lblHealthIndex.textColor = [UIColor whiteColor];
    lblHealthIndex.font = [UIFont boldSystemFontOfSize:26.f];
    lblHealthIndex.textAlignment = NSTextAlignmentCenter;
    [imgHeathIndex addSubview:lblHealthIndex];
    
    UILabel *lblDescription1 = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 190, 30)];
    UILabel *lblDescription2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 20, 30)];
    lblHealthIndexGreatThan = [[UILabel alloc] initWithFrame:CGRectMake(150, 52, 50, 40)];
    UILabel *lblDescription3 = [[UILabel alloc] initWithFrame:CGRectMake(197, 60, 100, 30)];
    
    [imgHeathIndex addSubview:lblDescription1];
    [imgHeathIndex addSubview:lblDescription2];
    [imgHeathIndex addSubview:lblHealthIndexGreatThan];
    [imgHeathIndex addSubview:lblDescription3];
    
    lblDescription1.textColor = [UIColor whiteColor];
    lblDescription2.textColor = [UIColor whiteColor];
    lblDescription3.textColor = [UIColor whiteColor];
    lblHealthIndexGreatThan.textColor = [UIColor yellowColor];
    
    lblDescription1.font = [UIFont systemFontOfSize:17.f];
    lblDescription2.font = [UIFont systemFontOfSize:17.f];
    lblDescription3.font = [UIFont systemFontOfSize:17.f];
    lblHealthIndexGreatThan.font = [UIFont systemFontOfSize:22.f];
    
    lblDescription1.text = NSLocalizedString(@"heath_index_desc_tips1", @"");
    lblDescription2.text = NSLocalizedString(@"heath_index_desc_tips2", @"");
    lblHealthIndexGreatThan.text = @"81%";
    lblDescription3.text = NSLocalizedString(@"heath_index_desc_tips3", @"");
    
    lblDescription1.backgroundColor = [UIColor clearColor];
    lblDescription2.backgroundColor = [UIColor clearColor];
    lblHealthIndexGreatThan.backgroundColor = [UIColor clearColor];
    lblDescription3.backgroundColor = [UIColor clearColor];
    
    /*
     * Create sensors display view
     */
    UIView *displayPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, imgHeathIndex.frame.origin.y + imgHeathIndex.frame.size.height, [UIScreen mainScreen].bounds.size.width, 84)];
    displayPanelView.backgroundColor = [UIColor appGray];
    [scrollView addSubview:displayPanelView];
    
    SensorDisplayView *sensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 10) andDevice:nil];
    [displayPanelView addSubview:sensor];
    
    SensorDisplayView *sensor1 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 10) andDevice:nil];
    [displayPanelView addSubview:sensor1];
    
    SensorDisplayView *sensor2 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 47) andDevice:nil];
    [displayPanelView addSubview:sensor2];
    
    SensorDisplayView *sensor3 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 47) andDevice:nil];
    [displayPanelView addSubview:sensor3];
    
    /*
     * Add blue line
     */
    UIImageView *imgLineBlue = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, displayPanelView.bounds.size.width, 11)];
    imgLineBlue.image = [UIImage imageNamed:@"line_seperator_heavy_blue"];
    [displayPanelView addSubview:imgLineBlue];
    
    /*
     * Add separator line
     */
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, displayPanelView.bounds.size.height - 2, displayPanelView.bounds.size.width, 2)];
    imgLine.image = [UIImage imageNamed:@"line_dashed"];
    [displayPanelView addSubview:imgLine];
    
    /*
     * Create unit control panel view
     */
    UnitControlPanel *controlPanelView = [[UnitControlPanel alloc] initWithPoint:CGPointMake(0, displayPanelView.frame.origin.y + displayPanelView.bounds.size.height)];
    [scrollView addSubview:controlPanelView];
    
    CGFloat totalHeight = 0.f;
    for(UIView *view in scrollView.subviews) {
        totalHeight += view.bounds.size.height;
    }
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, totalHeight);
}


@end
