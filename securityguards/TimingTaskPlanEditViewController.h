//
//  TimingTaskPlanEditViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@interface TimingTaskPlanEditViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithUnit:(Unit *)unit;

@property (nonatomic, strong) Unit *unit;

@end
