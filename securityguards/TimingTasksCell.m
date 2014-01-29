//
//  TimingTasksCell.m
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTasksCell.h"
#import "UIColor+MoreColor.h"

@implementation TimingTasksCell {
    UILabel *lblTaskPlanName;
    UILabel *lblTaskPlanSceduleTime;
    UILabel *lblTaskPlanSceduleDate;
    UILabel *lblScheduleMode;
    
    UISwitch *swhTaskPlanEnable;
}

@synthesize timingTask = _timingTask_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTimerTaskPlan:(TimingTask *)timingTask reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initUI];
        self.timingTask = timingTask;
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor appDarkGray];
    
    lblTaskPlanName = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 160, 23)];
    lblTaskPlanSceduleTime = [[UILabel alloc] initWithFrame:CGRectMake(169, 3, 70, 29)];
    lblTaskPlanSceduleDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 20)];
    lblScheduleMode = [[UILabel alloc] initWithFrame:CGRectMake(174, 30, 60, 20)];
    
    lblTaskPlanSceduleDate.font = [UIFont systemFontOfSize:10.f];
    lblTaskPlanSceduleDate.textColor = [UIColor darkGrayColor];
    
    lblTaskPlanName.font = [UIFont systemFontOfSize:14.f];
    
    lblTaskPlanSceduleTime.font = [UIFont systemFontOfSize:23.f];
    lblTaskPlanSceduleTime.textColor = [UIColor appBlue];
    lblTaskPlanSceduleTime.textAlignment = NSTextAlignmentCenter;
    
    lblScheduleMode.font = [UIFont systemFontOfSize:10.f];
    lblScheduleMode.textColor = [UIColor darkGrayColor];
    
    lblTaskPlanName.backgroundColor = [UIColor clearColor];
    lblTaskPlanSceduleTime.backgroundColor = [UIColor clearColor];
    lblTaskPlanSceduleDate.backgroundColor = [UIColor clearColor];
    lblScheduleMode.backgroundColor = [UIColor clearColor];
    
    [self addSubview:lblTaskPlanName];
    [self addSubview:lblTaskPlanSceduleTime];
    [self addSubview:lblTaskPlanSceduleDate];
    [self addSubview:lblScheduleMode];
    
    swhTaskPlanEnable = [[UISwitch alloc] initWithFrame:CGRectZero];
    swhTaskPlanEnable.center = CGPointMake(281, 26.f);
    swhTaskPlanEnable.tintColor = [UIColor appDarkDarkGray];
    swhTaskPlanEnable.onTintColor = [UIColor appBlue];
    swhTaskPlanEnable.on = YES;
    
    [swhTaskPlanEnable addTarget:self action:@selector(valueDidChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:swhTaskPlanEnable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setTasksPlan:(TimingTask *)timingTask {
    _timingTask_ = timingTask;
    if(_timingTask_ == nil) {
        
        return;
    } else {
        lblTaskPlanName.text = timingTask.name;
        lblTaskPlanSceduleDate.text = [timingTask stringForScheduleDate];
        lblTaskPlanSceduleTime.text = [NSString stringWithFormat:@"%@ : %@",
                [self displayedStringForTimeInteger:timingTask.scheduleTimeHour],
                [self displayedStringForTimeInteger:timingTask.scheduleTimeMinute]];
        lblScheduleMode.text = (timingTask.scheduleMode == TaskScheduleModeNoRepeat) ?
            NSLocalizedString(@"exe_no_repeat", @"") : NSLocalizedString(@"exe_repeat", @"");
        swhTaskPlanEnable.on = timingTask.enable;
        [self valueDidChanged:swhTaskPlanEnable];
    }
}

- (void)valueDidChanged:(UISwitch *)switchView {
    if(switchView.isOn) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor appGray];
    }
#ifdef DEBUG
    NSLog(@"%@", switchView.isOn ? @"switch to on " : @"switch to off ");
#endif
}

- (NSString *)displayedStringForTimeInteger:(int)t {
    if(t > 9) {
        return [NSString stringWithFormat:@"%d", t];
    } else {
        return [NSString stringWithFormat:@"0%d", t];
    }
}

@end
