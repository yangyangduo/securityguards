//
//  RootViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RootViewController.h"
#import "PortalViewController.h"
#import "NewsViewController.h"
#import "AccountManagementViewController.h"
#import "CopyrightViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController {
    UINavigationController *portalNavViewController;
    UIViewController *displayViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    // init left view
    NSArray *navItems = [NSArray arrayWithObjects:
        [[LeftNavItem alloc] initWithIdentifier:@"portalItem" andDisplayName:NSLocalizedString(@"portal_drawer_title", @"") andImageName:@"icon_portal"],
        [[LeftNavItem alloc] initWithIdentifier:@"newsItem" andDisplayName:NSLocalizedString(@"news_drawer_title", @"") andImageName:@"icon_news"],
        [[LeftNavItem alloc] initWithIdentifier:@"accountManagerItem" andDisplayName:NSLocalizedString(@"account_mgr_drawer_title", @"") andImageName:@"icon_account"],
        [[LeftNavItem alloc] initWithIdentifier:@"copyrightItem" andDisplayName:NSLocalizedString(@"copyright_drawer_title", @"") andImageName:@"icon_copyright"],
        [[LeftNavItem alloc] initWithIdentifier:@"logoutItem" andDisplayName:NSLocalizedString(@"logout_drawer_title", @"") andImageName:@"icon_logout"], nil];
    LeftNavView *navView = [[LeftNavView alloc] initWithFrame:[UIScreen mainScreen].bounds andNavItems:navItems];
    navView.delegate = self;
    self.leftView = navView;
    
    // init center view
    if(navItems.count > 0) {
        [self leftNavViewItemChanged:[navItems objectAtIndex:0]];
    }
    
    self.leftViewVisibleWidth = 160;
    self.showDrawerMaxTrasitionX = 50;
    
    // setup
    [self initialDrawerViewController];
}

#pragma mark -
#pragma mark Left Nav View Delegate

- (void)leftNavViewItemChanged:(LeftNavItem *)item {
    // if the item is nil, we think it not changed
    if(item == nil) {
        [self showCenterView:YES];
        return;
    }
    
    UIViewController *centerViewController = nil;
    
    if([@"portalItem" isEqualToString:item.identifier]) {
        if(portalNavViewController == nil) {
            portalNavViewController = [[UINavigationController alloc] initWithRootViewController:[[PortalViewController alloc] init]];
            portalNavViewController.navigationBarHidden = YES;
            centerViewController = portalNavViewController;
        } else {
            centerViewController = portalNavViewController;
        }
    } else if([@"newsItem" isEqualToString:item.identifier]) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
        navController.navigationBarHidden = YES;
        centerViewController = navController;
    } else if([@"accountManagerItem" isEqualToString:item.identifier]) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[AccountManagementViewController alloc] init]];
        navController.navigationBarHidden = YES;
        centerViewController = navController;
    } else if([@"copyrightItem" isEqualToString:item.identifier]) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[CopyrightViewController alloc] init]];
        navController.navigationBarHidden = YES;
        centerViewController = navController;
    }
    
    if(centerViewController == nil) return;
    
    [self addChildViewController:centerViewController];
    if(displayViewController != nil) {
        [displayViewController willMoveToParentViewController:nil];
    }
    self.centerView = centerViewController.view;
    [centerViewController didMoveToParentViewController:self];
    if(displayViewController != nil) {
        [displayViewController removeFromParentViewController];
    }
    displayViewController = centerViewController;
    [self showCenterView:YES];
}

@end
