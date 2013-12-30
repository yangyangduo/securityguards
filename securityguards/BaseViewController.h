//
//  BaseViewController.h
//  funding
//
//  Created by Zhao yang on 12/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopbarView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) TopbarView *topbarView;

- (void)initDefaults;
- (void)initUI;
- (void)setUp;

- (void)registerTapGestureToResignKeyboard;
- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture;
- (void)resignFirstResponderFor:(UIView *)view;

@end
