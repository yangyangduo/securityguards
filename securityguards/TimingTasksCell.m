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
@synthesize delegte;

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
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor appDarkGray];
    
    lblTaskPlanName = [[UILabel alloc] initWithFrame:CGRectMake(13, 6, 160, 23)];
    lblTaskPlanSceduleTime = [[UILabel alloc] initWithFrame:CGRectMake(152, 3, 80, 29)];
    lblTaskPlanSceduleDate = [[UILabel alloc] initWithFrame:CGRectMake(13, 30, 150, 20)];
    lblScheduleMode = [[UILabel alloc] initWithFrame:CGRectMake(162, 30, 60, 20)];
    
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
    
    [self.contentView addSubview:lblTaskPlanName];
    [self.contentView addSubview:lblTaskPlanSceduleTime];
    [self.contentView addSubview:lblTaskPlanSceduleDate];
    [self.contentView addSubview:lblScheduleMode];
    
    swhTaskPlanEnable = [[UISwitch alloc] initWithFrame:CGRectMake(lblScheduleMode.frame.origin.x + 95, 10, 30, 0)];
    swhTaskPlanEnable.tintColor = [UIColor appDarkDarkGray];
    swhTaskPlanEnable.onTintColor = [UIColor appBlue];
    swhTaskPlanEnable.on = YES;
    swhTaskPlanEnable.hidden = NO;
    [swhTaskPlanEnable addTarget:self action:@selector(valueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [swhTaskPlanEnable addTarget:self action:@selector(swhPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:swhTaskPlanEnable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    if(state == UITableViewCellStateShowingEditControlMask) {
        swhTaskPlanEnable.hidden = YES;
    } else {
        swhTaskPlanEnable.hidden = NO;
    }
    [super willTransitionToState:state];
}

- (void)showSwitchButton {
    swhTaskPlanEnable.hidden = NO;
}

- (void)hideSwitchButton {
    swhTaskPlanEnable.hidden = YES;
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    swhTaskPlanEnable.hidden = editing;
//}

- (void)setTimingTask:(TimingTask *)timingTask {
    _timingTask_ = timingTask;
    if(_timingTask_ == nil) {
        lblTaskPlanName.text = [XXStringUtils emptyString];
        lblTaskPlanSceduleDate.text = [XXStringUtils emptyString];
        lblTaskPlanSceduleTime.text = [XXStringUtils emptyString];
        lblScheduleMode.text = [XXStringUtils emptyString];
        swhTaskPlanEnable.enabled = NO;
        [self valueDidChanged:swhTaskPlanEnable];
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
    swhTaskPlanEnable.hidden = self.isEditing;
}

- (void)valueDidChanged:(UISwitch *)switchView {
    if(switchView.isOn) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor appGray];
    }
}

- (void)swhPressed:(id)sender {
    if(self.timingTask != nil && self.delegte != nil
       && [self.delegte respondsToSelector:@selector(timingTaskStateChanged:withState:)]) {
        [self.delegte timingTaskStateChanged:self withState:swhTaskPlanEnable.isOn];
    }
}

- (NSString *)displayedStringForTimeInteger:(int)t {
    if(t > 9) {
        return [NSString stringWithFormat:@"%d", t];
    } else {
        return [NSString stringWithFormat:@"0%d", t];
    }
}

- (void)revertSwitchButton {
    [self performSelector:@selector(revertSwitchButtonInternal) withObject:nil afterDelay:1.5f];
}

- (void)revertSwitchButtonInternal {
    [swhTaskPlanEnable setOn:self.timingTask.enable animated:YES];
    [self valueDidChanged:swhTaskPlanEnable];
}

- (BOOL)valueForSwitchButton {
    return swhTaskPlanEnable.isOn;
}

@end

