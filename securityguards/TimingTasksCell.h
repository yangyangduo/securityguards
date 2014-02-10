//
//  TimingTasksCell.h
//  securityguards
//
//  Created by Zhao yang on 2/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimingTask.h"

@protocol TimingTaskCellDelegate;

@interface TimingTasksCell : UITableViewCell

@property (nonatomic, strong) TimingTask *timingTask;
@property (nonatomic, weak) id<TimingTaskCellDelegate> delegte;

- (instancetype)initWithTimerTaskPlan:(TimingTask *)timingTask reuseIdentifier:(NSString *)reuseIdentifier;

- (void)revertSwitchButton;
- (BOOL)valueForSwitchButton;

@end

@protocol TimingTaskCellDelegate <NSObject>

- (void)timingTaskStateChanged:(TimingTasksCell *)timingTasksCell withState:(BOOL)isEnable;

@end
