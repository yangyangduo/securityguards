//
//  TimerTaskCell.h
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerTaskPlan.h"

@interface TimerTaskCell : UITableViewCell

@property (nonatomic, strong) TimerTaskPlan *taskPlan;

- (instancetype)initWithTimerTaskPlan:(TimerTaskPlan *)timerTaskPlan reuseIdentifier:(NSString *)reuseIdentifier;

@end
