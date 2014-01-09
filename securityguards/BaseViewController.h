//
//  BaseViewController.h
//  funding
//
//  Created by Zhao yang on 12/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopbarView.h"
#import "XXStringUtils.h"
#import "GlobalSettings.h"
#import "UIColor+HexColor.h"
#import "UIColor+MoreColor.h"
#import "UIDevice+SystemVersion.h"
#import "AlertView.h"
#import "CoreService.h"
#import "JsonUtils.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"
#import "XXEventNameFilter.h"
#import "XXEventSubscriptionPublisher.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) TopbarView *topbarView;

- (void)initDefaults;
- (void)initUI;
- (void)setUp;

- (void)registerTapGestureToResignKeyboard;
- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture;
- (void)resignFirstResponderFor:(UIView *)view;

- (void)showEmptyContentViewWithMessage:(NSString *)message;
- (void)removeEmptyContentView;

- (void)showLoadingViewWithMessage:(NSString *)message;
- (void)removeLoadingView;

@end
