//
//  TimerTaskPlan.h
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"

typedef enum {
    TaskSceduleDateNone        =    0,
    TaskSceduleDateMonday      =    1 << 0,
    TaskSceduleDateTuesday     =    1 << 1,
    TaskSceduleDateWednesday   =    1 << 2,
    TaskSceduleDateThursday    =    1 << 3,
    TaskSceduleDateFriday      =    1 << 4,
    TaskSceduleDateSaturday    =    1 << 5,
    TaskSceduleDateSunday      =    1 << 6,
} TaskSceduleDate;


typedef enum {
    TaskSceduleModeNoRepeat = 0,
    TaskSceduleModeRepeat   = 1
} TaskSceduleMode;

/**
 *
 lblTaskPlanName.text = @"开启安防";
 lblTaskPlanSceduleDate.text = @"周一、二、三、四、五、六、日";
 lblTaskPlanSceduleTime.text = @"01 : 00";
 lblScheduleMode.text = @"每周重复执行";
 */
@interface TimerTaskPlan : Entity

@property (nonatomic, strong) NSString *name;
@property (nonatomic) TaskSceduleDate scheduleDate;
@property (nonatomic) TaskSceduleMode scheduleMode;
@property (nonatomic) NSString *scheduleTime;

@end
