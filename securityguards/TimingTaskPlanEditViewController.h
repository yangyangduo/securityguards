//
//  TimingTaskPlanEditViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"
#import "TextViewController.h"
#import "TimingTask.h"

@interface TimingTaskPlanEditViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, TextViewDelegate>

- (instancetype)initWithUnit:(Unit *)unit timingTask:(TimingTask *)timingTask;

@property (nonatomic, strong) Unit *unit;
@property (nonatomic, strong) TimingTask *timingTask;

@end
