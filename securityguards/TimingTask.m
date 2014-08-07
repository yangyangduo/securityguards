//
//  TimingTasks.m
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTask.h"
#import "ChineseUtils.h"
#import "XXActionSheet.h"
#import "GlobalSettings.h"

@implementation TimingTask {
    
}

@synthesize identifier;
@synthesize isSystemTask;
@synthesize name;
@synthesize enable;
@synthesize isOwner;
@synthesize unitIdentifier;
@synthesize scheduleDate;
@synthesize scheduleTimeHour;
@synthesize scheduleTimeMinute;
@synthesize scheduleMode;
@synthesize timingTaskExecutionItems = _timingTaskExecutionItems_;
@synthesize unit = _unit_;

- (id)copy {
    TimingTask *newTimingTask = [[TimingTask alloc] init];
    newTimingTask.identifier = self.identifier;
    newTimingTask.name = self.name;
    newTimingTask.enable = self.enable;
    newTimingTask.isOwner = self.isOwner;
    newTimingTask.unitIdentifier = self.unitIdentifier;
    newTimingTask.scheduleDate = self.scheduleDate;
    newTimingTask.scheduleTimeHour = self.scheduleTimeHour;
    newTimingTask.scheduleTimeMinute = self.scheduleTimeMinute;
    newTimingTask.scheduleMode = self.scheduleMode;
    newTimingTask.isSystemTask = self.isSystemTask;
    newTimingTask.unit = _unit_;
    
    for(int i=0; i<self.timingTaskExecutionItems.count; i++) {
        [newTimingTask.timingTaskExecutionItems addObject:
            [[self.timingTaskExecutionItems objectAtIndex:i] copy]];
    }
    
    return newTimingTask;
}

- (instancetype)initWithJson:(NSDictionary *)json forUnit:(Unit *)unit {
    self = [super initWithJson:json];
    if(self && json) {
        // set id
        self.identifier = [json noNilStringForKey:@"id"];
        
        // set unit identifier
        NSString *_device_code_ = [json noNilStringForKey:@"dc"];
        if(![XXStringUtils isBlank:_device_code_] && _device_code_.length > 4) {
            self.unitIdentifier = [_device_code_ substringToIndex:_device_code_.length - 4];
        } else {
            self.unitIdentifier = _device_code_;
        }
        
        // set name
        self.name = [json noNilStringForKey:@"na"];
        
        // set is enabled
        self.enable = [json booleanForKey:@"en"];
        
        // set is or not system task
        self.isSystemTask = [json booleanForKey:@"sy"];
        
        // set schedule is or not repeat
        self.scheduleMode = [json booleanForKey:@"on"] ? TaskScheduleModeNoRepeat : TaskScheduleModeRepeat;
        
        // set schedule dates
        NSDictionary *_schedule_dates_json_ = [json dictionaryForKey:@"sc"];
        if(_schedule_dates_json_ != nil) {
            for(int i=1; i<=7; i++) {
                NSString *shotWeekString = [NSString stringWithFormat:@"w%d", i];
                if([_schedule_dates_json_ booleanForKey:shotWeekString]) {
                    self.scheduleDate |= (1 << (i - 1));
                }
            }
            self.scheduleTimeHour = [_schedule_dates_json_ intForKey:@"hr"];
            self.scheduleTimeMinute = [_schedule_dates_json_ intForKey:@"mi"];
        }
        
        // configure default executions list for the unit;
        _unit_ = unit;
        if(_unit_ != nil) {
            for(int i=0; i<_unit_.devices.count; i++) {
                Device *device = [_unit_.devices objectAtIndex:i];
                if(device.isAirPurifier || device.isSocket) {
                    TimingTaskExecutionItem *item = [[TimingTaskExecutionItem alloc] init];
                    item.device = device;
                    item.deviceIdentifier = device.identifier;
                    [self.timingTaskExecutionItems addObject:item];
                }
            }
        }
        
        // update executions for default items list
        NSArray *_executions_json_ = [json arrayForKey:@"ex"];
        if(_executions_json_ != nil) {
            for(int i=0; i<_executions_json_.count; i++) {
                NSDictionary *_execution_json_ = [_executions_json_ objectAtIndex:i];
                for(int j=0; j<self.timingTaskExecutionItems.count; j++) {
                    TimingTaskExecutionItem *item = [self.timingTaskExecutionItems objectAtIndex:j];
                    if([item.deviceIdentifier isEqualToString:[_execution_json_ noNilStringForKey:@"cd"]]) {
                        [item updateWithJson:_execution_json_];
                        break;
                    }
                }
            }
        }
        
    }
    return self;
}


- (instancetype)initWithUnit:(Unit *)unit {
    self = [super init];
    _unit_ = unit;
    if(self && _unit_) {
        // configure default value for this plan
        NSDate *now = [NSDate date];
        NSDateComponents *dc = [[NSCalendar currentCalendar] components:
                                (NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now];
        
        self.unitIdentifier = _unit_.identifier;
        self.name = NSLocalizedString(@"timing_tasks_plan_default_name", @"");
        self.enable = YES;
        self.scheduleMode = TaskScheduleModeNoRepeat;
        self.scheduleDate = (1 << (dc.weekday - 2));
        self.scheduleTimeHour = dc.hour;
        self.scheduleTimeMinute = dc.minute;
        
        for(int i=0; i<_unit_.devices.count; i++) {
            Device *device = [_unit_.devices objectAtIndex:i];
            if(device.isAirPurifier || device.isSocket) {
                TimingTaskExecutionItem *item = [[TimingTaskExecutionItem alloc] init];
                item.device = device;
                item.deviceIdentifier = device.identifier;
                [self.timingTaskExecutionItems addObject:item];
            }
        }
    }
    
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    // set basic info
    [json setNoBlankString:self.identifier forKey:@"id"];
    [json setMayBlankString:[NSString stringWithFormat:@"%@%@", self.unitIdentifier, APP_KEY] forKey:@"dc"];
    [json setMayBlankString:self.name forKey:@"na"];
    [json setBoolean:self.enable forKey:@"en"];
    [json setBoolean:(self.scheduleMode == TaskScheduleModeNoRepeat) forKey:@"on"];
    [json setBoolean:self.isSystemTask forKey:@"sy"];

    // set executions
    NSMutableArray *_executions_ = [NSMutableArray array];
    for(int i=0; i<self.timingTaskExecutionItems.count; i++) {
        TimingTaskExecutionItem *executionItem = [self.timingTaskExecutionItems objectAtIndex:i];
        if(executionItem.isAvailable) {
            [_executions_ addObject:[executionItem toJson]];
        }
    }
    [json setNoNilObject:_executions_ forKey:@"ex"];
    
    // set schedule dates
    NSMutableDictionary *_schedule_dates_ = [NSMutableDictionary dictionary];
    [_schedule_dates_ setInteger:self.scheduleTimeHour forKey:@"hr"];
    [_schedule_dates_ setInteger:self.scheduleTimeMinute forKey:@"mi"];
    for(int i=0; i<7; i++) {
        BOOL containsThisDayOfWeek = (self.scheduleDate & (1 << i)) == (1 << i);
        [_schedule_dates_ setBoolean:containsThisDayOfWeek forKey:[NSString stringWithFormat:@"w%d", (i + 1)]];
    }
    
    [json setNoNilObject:_schedule_dates_ forKey:@"sc"];
    
    return json;
}

- (NSString *)stringForScheduleDate {
    if(self.scheduleDate == (TaskScheduleDateMonday | TaskScheduleDateTuesday | TaskScheduleDateWednesday | TaskScheduleDateThursday | TaskScheduleDateFriday | TaskScheduleDateSaturday | TaskScheduleDateSunday)) {
        return NSLocalizedString(@"everyday", @"");
    }
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    if(self.scheduleMode == TaskScheduleModeRepeat) {
        [ms appendString:NSLocalizedString(@"per", @"")];
    }
    BOOL appendAtLeastOneItem = NO;
    for(int i=0; i<7; i++) {
        if((self.scheduleDate & (1 << i)) == (1 << i)) {
            if(appendAtLeastOneItem) {
                [ms appendString:@"、"];
            } else {
                [ms appendString:NSLocalizedString(@"week", @"")];
            }
            [ms appendString:[ChineseUtils chineseWeekForInt:(i + 1)]];
            appendAtLeastOneItem = YES;
        }
    }
    return ms;
}

- (NSMutableArray *)timingTaskExecutionItems {
    if(_timingTaskExecutionItems_ == nil) {
        _timingTaskExecutionItems_ = [NSMutableArray array];
    }
    return _timingTaskExecutionItems_;
}

@end