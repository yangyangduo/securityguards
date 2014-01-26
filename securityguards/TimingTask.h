//
//  TimingTasks.h
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"

typedef enum {
    TaskScheduleDateNone        =    0,
    TaskScheduleDateMonday      =    1 << 0,
    TaskScheduleDateTuesday     =    1 << 1,
    TaskScheduleDateWednesday   =    1 << 2,
    TaskScheduleDateThursday    =    1 << 3,
    TaskScheduleDateFriday      =    1 << 4,
    TaskScheduleDateSaturday    =    1 << 5,
    TaskScheduleDateSunday      =    1 << 6,
} TaskScheduleDate;


typedef enum {
    TaskScheduleModeNoRepeat = 0,
    TaskScheduleModeRepeat   = 1
} TaskScheduleMode;


@interface TimingTask : Entity

@property (nonatomic, strong) NSString *name;
@property (nonatomic) TaskScheduleDate scheduleDate;
@property (nonatomic) int scheduleTimeHour;
@property (nonatomic) int scheduleTimeMinute;
@property (nonatomic) TaskScheduleMode scheduleMode;

- (NSString *)stringForScheduleDate;

@end
