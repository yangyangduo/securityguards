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
#import "UIColor+MoreColor.h"

@interface PortalViewController ()

@end

@implementation PortalViewController {
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
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 8 - 55 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? (20 + 8) : 8, 55 / 2, 55 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_drawer_right"] forState:UIControlStateNormal];
    [self.topbarView addSubview:btnRight];
    
    UIImageView *imgHeathIndex = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 120)];
    imgHeathIndex.image = [UIImage imageNamed:@"bg_health_index"];
    [self.view addSubview:imgHeathIndex];
    
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

    UIView *displayPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, imgHeathIndex.frame.origin.y + imgHeathIndex.frame.size.height, [UIScreen mainScreen].bounds.size.width, 84)];
    displayPanelView.backgroundColor = [UIColor appGray];
    [self.view addSubview:displayPanelView];
    
    SensorDisplayView *sensor = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 10) andDevice:nil];
    [displayPanelView addSubview:sensor];
    
    
    SensorDisplayView *sensor1 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 10) andDevice:nil];
    [displayPanelView addSubview:sensor1];
    
    SensorDisplayView *sensor2 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(10, 47) andDevice:nil];
    [displayPanelView addSubview:sensor2];
    
    
    SensorDisplayView *sensor3 = [[SensorDisplayView alloc] initWithPoint:CGPointMake(170, 47) andDevice:nil];
    [displayPanelView addSubview:sensor3];
    
}

@end
