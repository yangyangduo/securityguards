//
//  TimingTasksCell.h
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimingTask.h"

@interface TimingTasksCell : UITableViewCell

@property (nonatomic, strong) TimingTask *timingTask;

- (instancetype)initWithTimerTaskPlan:(TimingTask *)timingTask reuseIdentifier:(NSString *)reuseIdentifier;

@end
