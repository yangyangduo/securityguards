//
//  AppDelegate.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "UnitSettingStep4ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (UIViewController *)topViewController;
- (RootViewController *)rootViewController;

- (void)registerForRemoteNotifications;

- (void)logout;

@end
