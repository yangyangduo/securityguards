//
//  TimerTaskCell.m
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimerTaskCell.h"
#import "UIColor+MoreColor.h"

@implementation TimerTaskCell {
    UILabel *lblTaskPlanName;
    UILabel *lblTaskPlanSceduleTime;
    UILabel *lblTaskPlanSceduleDate;
    UILabel *lblScheduleMode;
    
    UISwitch *swhTaskPlanEnable;
}

@synthesize taskPlan = _taskPlan_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTimerTaskPlan:(TimerTaskPlan *)timerTaskPlan reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initUI];
        self.taskPlan = timerTaskPlan;
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

    lblTaskPlanName.text = @"开启安防";
    lblTaskPlanSceduleDate.text = @"周一、二、三、四、五、六、日";
    lblTaskPlanSceduleTime.text = @"01 : 00";
    lblScheduleMode.text = @"每周重复执行";
    
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

- (void)setTaskPlan:(TimerTaskPlan *)taskPlan {
    _taskPlan_ = taskPlan;
    if(_taskPlan_ == nil) {
        return;
    } else {
        
    }
}

- (void)valueDidChanged:(UISwitch *)switchView {
    if(switchView.isOn) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor appGray];
    }
    NSLog(@"%@", switchView.isOn ? @" is on " : @" is off ");
}

@end
