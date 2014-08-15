//
//  AppDelegate.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AppDelegate.h"
#import "UnitManager.h"
#import "UserLogoutEvent.h"
#import "Memory.h"
#import "SecurityGuards.h"
#import "ShoppingCart.h"
#import "UIColor+XXImage.h"
#import "Shared.h"

#import <Frontia/Frontia.h>

@implementation AppDelegate {
    // Not really root view controller (Really root view controller is it's super view controller UI Navigation View Controller).
    RootViewController *_rootViewController_;
    
    // Boolean value to flat app wether logouting
    BOOL logouting;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init Baidu Frontia Module
    [self initBaiduShareKits];

    // Init UI
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _rootViewController_ = [[RootViewController alloc] init];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:_rootViewController_];

    // Use Custom Navigation Bar
    navigationViewController.navigationBarHidden = YES;
    
    self.window.rootViewController = navigationViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"[APP] Resign active.");
#endif
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"[APP] Did enter background.");
#endif
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[CoreService defaultService] stopService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"[APP] Will Enter foregroud");
#endif
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if([GlobalSettings defaultSettings].hasLogin) {
        [[CoreService defaultService] startService];
    }

    UIViewController *topViewController = self.topViewController;
    if(topViewController != nil && [topViewController isKindOfClass:[UnitSettingStep4ViewController class]]) {
        UnitSettingStep4ViewController *unitStep4ViewController = (UnitSettingStep4ViewController *)topViewController;
        [unitStep4ViewController detectionFamilyGuardsWifiExists];
#ifdef DEBUG
        NSLog(@"[APP] UnitSettingStep4ViewController Is Already Exists.");
#endif
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"[APP] Will terminate.");
#endif
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// ios4.2 以后就废除了
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[Frontia getShare] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
#ifdef DEBUG
    NSLog(@"[APP] Open url [%@] --> source app [%@].", url.description, sourceApplication);
#endif
    return [[Frontia getShare] handleOpenURL:url];
}

#pragma mark -
#pragma mark Top View Controller

- (UIViewController *)topViewController {
    return [[UIApplication sharedApplication] topViewController:_rootViewController_.navigationController];
}

- (RootViewController *)rootViewController {
    return _rootViewController_;
}

#pragma mark -
#pragma mark Baidu Share Kits

- (void)initBaiduShareKits {
    [Frontia initWithApiKey:BAIDU_FRONTIA_APP_KEY];
    [[Frontia getShare] registerQQAppId:TENCENT_QQ_APP_KEY enableSSO:YES];
    [[Frontia getShare] registerSinaweiboAppId:SINA_WEIBO_APP_KEY];
    [[Frontia getShare] registerWeixinAppId:WECHAT_APP_KEY];
}

#pragma mark -
#pragma mark Logout

- (void)logout {
    if(!logouting) {
        logouting = YES;
        
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"logouting", @"") forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        
        // Stop Core Service
        [[CoreService defaultService] stopService];
        
        // Remove All Subscriptions But 'rootViewControllerSubscriber'
        [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeAllSubscriptionsExceptSubscriberId:@"rootViewControllerSubscriber"];
        
        // Clear Unit Manager (All zones, units and devices)
        [[UnitManager defaultManager] clear];
        
        // Clear User Auth (Login Security key, User name and so on)
        [[GlobalSettings defaultSettings] clearAuth];
        
        // Clear All Merchandises in Shopping cart
        [[ShoppingCart shoppingCart] clearShoppingCart];
        
        // Clear All Data in Memory
        [[Memory memory] clearAll];
        
        // Clear all Authorization for each Share Platform
        [[Frontia getAuthorization] clearAllAuthorizationInfo];
        
        // Reset root view controller
        [self.rootViewController.portalViewController reset];
        
        LeftNavView *leftView = (LeftNavView *)[Shared shared].app.rootViewController.leftView;
        [leftView setScreenName:@""];
        
        // UI ...
        [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(delayLogout) userInfo:nil repeats:NO];
    }
}

- (void)delayLogout {
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    loginNavController.navigationBarHidden = YES;
    [[self topViewController] presentViewController:loginNavController animated:NO completion:^{}];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[UserLogoutEvent alloc] init]];
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"logout_success", @"") forType:AlertViewTypeSuccess];
    [[XXAlertView currentAlertView] delayDismissAlertView];
    logouting = NO;
}

@end
