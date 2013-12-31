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
#import "UnitManager.h"
#import "GlobalSettings.h"
#import "AlertView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[RootViewController alloc] init];
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
    if(![XXStringUtils isBlank:[GlobalSettings defaultSettings].secretKey]
       && ![XXStringUtils isBlank:[GlobalSettings defaultSettings].deviceCode]) {
        [[CoreService defaultService] startService];
        [[CoreService defaultService] startRefreshCurrentUnit];
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

- (void)logout {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"logouting", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(delayLogout) userInfo:nil repeats:NO];
}

- (void)delayLogout {
    [[CoreService defaultService] stopService];
    [[XXEventSubscriptionPublisher defaultPublisher] unsubscribeAllSubscriptions];
    [[UnitManager defaultManager] clear];
    [[GlobalSettings defaultSettings] clearAuth];
    
    if(self.window.rootViewController != nil && [self.window.rootViewController isKindOfClass:[RootViewController class]]) {
        RootViewController *rootViewController = (RootViewController *)self.window.rootViewController;
        if(rootViewController.displayViewController != nil) {
            UIViewController *controller;
            if([rootViewController.displayViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navViewController = (UINavigationController *)rootViewController.displayViewController;
                if(navViewController.viewControllers.count > 0) {
                    controller = [navViewController.viewControllers objectAtIndex:0];
                }
            } else {
                controller = rootViewController.displayViewController;
            }
            if(controller != nil && [controller isKindOfClass:[DrawerViewController class]]) {
                DrawerViewController *drawerViewController = (DrawerViewController *)controller;
                [drawerViewController showLoginViewController];
            }
        }
    }
    
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"logout_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
}

@end
