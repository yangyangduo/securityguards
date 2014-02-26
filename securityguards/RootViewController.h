//
//  RootViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXDrawerViewController.h"
#import "PortalViewController.h"
#import "XXEventSubscriber.h"
#import "LeftNavView.h"

@interface RootViewController : XXDrawerViewController<LeftNavViewDelegate, XXEventSubscriber>

@property (nonatomic, strong) UIViewController *displayViewController;

- (PortalViewController *)portalViewController;
- (void)changeViewControllerWithIdentifier:(NSString *)identifier;

@end
