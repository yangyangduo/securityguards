//
//  TimingTaskScheduleDateEditViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@interface TimingTaskScheduleDateEditViewController : NavigationViewController<UITableViewDelegate, UITableViewDataSource>

/*
 
 0000 0001   schedule on monday
 0000 0010   schedule on tuesday
 0000 0100   ...
 0000 1000   ...
 0001 0000
 0010 0000
 0100 0000
 1000 0000
 
 */
@property(nonatomic) int bitScheduleDates;
@property(nonatomic) BOOL isScheduleOnce;

- (instancetype)initWithBitScheduleDate:(int)bitScheduleDates isScheduleOnce:(BOOL)isScheduleOnce;

@end
