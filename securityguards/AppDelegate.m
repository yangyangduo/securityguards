//
//  AppDelegate.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreService.h"
#import "XXEventSubscriptionPublisher.h"
#import "UIApplication+TopViewController.h"
#import "UnitManager.h"
#import "GlobalSettings.h"
#import "AlertView.h"
#import "UserLogoutEvent.h"
#import "ShoppingCart.h"

#import "MyOperation.h"

@implementation AppDelegate {
    RootViewController *_rootViewController_;
    BOOL logouting;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    _rootViewController_ = [[RootViewController alloc] init];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:_rootViewController_];
    navigationViewController.navigationBarHidden = YES;

    self.window.rootViewController = navigationViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[CoreService defaultService] stopService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if([GlobalSettings defaultSettings].hasLogin) {
        [[CoreService defaultService] startService];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Top View Controller

- (UIViewController *)topViewController {
    return [[UIApplication sharedApplication] topViewController:_rootViewController_];
}

- (RootViewController *)rootViewController {
    return _rootViewController_;
}

#pragma mark -
#pragma mark Logout

- (void)logout {
    if(!logouting) {
        logouting = YES;
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"logouting", @"") forType:AlertViewTypeWaitting];
        [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        [[CoreService defaultService] stopService];
        [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeAllSubscriptionsExceptSubscriberId:@"rootViewControllerSubscriber"];
        [[UnitManager defaultManager] clear];
        [[GlobalSettings defaultSettings] clearAuth];
        [[ShoppingCart shoppingCart] clearShoppingCart];
        [self.rootViewController.portalViewController reset];
        [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(delayLogout) userInfo:nil repeats:NO];
    }
}

- (void)delayLogout {
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    loginNavController.navigationBarHidden = YES;
    [[self topViewController] presentViewController:loginNavController animated:NO completion:^{}];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[UserLogoutEvent alloc] init]];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"logout_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
    logouting = NO;
}

@end
