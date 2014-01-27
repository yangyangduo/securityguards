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

static NSArray * shortWeekStrings() {
    static NSArray *shotWeekStrings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shotWeekStrings = [NSArray arrayWithObjects:@"mon", @"tue", @"wed", @"thu", @"fri", @"sat", @"sun", nil];
    });
    return shotWeekStrings;
}

@implementation TimingTask {

}

@synthesize identifier;
@synthesize name;
@synthesize enable;
@synthesize unitIdentifier;
@synthesize scheduleDate;
@synthesize scheduleTimeHour;
@synthesize scheduleTimeMinute;
@synthesize scheduleMode;
@synthesize timingTaskExecutionItems = _timingTaskExecutionItems_;
@synthesize unit = _unit_;

- (instancetype)initWithJson:(NSDictionary *)json forUnit:(Unit *)unit {
    self = [super initWithJson:json];
    if(self && json) {
        // set id
        self.identifier = [json noNilStringForKey:@"id"];
        
        // set unit identifier
        self.unitIdentifier = [json noNilStringForKey:@"device"];
        
        // set name
        self.name = [json noNilStringForKey:@"name"];
        
        // set is enabled
        self.enable = [json boolForKey:@"enabled"];
        
        // set schedule is or not repeat
        self.scheduleMode = [json boolForKey:@"once"] ? TaskScheduleModeNoRepeat : TaskScheduleModeRepeat;
        
        // set schedule dates
        NSDictionary *_schedule_dates_json_ = [json dictionaryForKey:@"schedule"];
        if(_schedule_dates_json_ != nil) {
            for(int i=0; i<shortWeekStrings().count; i++) {
                NSString *shotWeekString = [shortWeekStrings() objectAtIndex:i];
                if([_schedule_dates_json_ boolForKey:shotWeekString]) {
                    self.scheduleDate |= (1 << i);
                }
            }
            
            self.scheduleTimeHour = [_schedule_dates_json_ intForKey:@"hour"];
            self.scheduleTimeMinute = [_schedule_dates_json_ intForKey:@"minute"];
        }
        
        // configure default executions list for the unit;
        _unit_ = unit;
        if(_unit_ != nil) {
            for(int i=0; i<_unit_.devices.count; i++) {
                Device *device = [_unit_.devices objectAtIndex:i];
                if(device.isAirPurifier) {
                    TimingTaskExecutionItem *item = [[TimingTaskExecutionItem alloc] init];
                    item.deviceIdentifier = device.identifier;
                    [self.timingTaskExecutionItems addObject:item];
                }
            }
        }
        
        // update executions for default items list
        NSArray *_executions_json_ = [json arrayForKey:@"executions"];
        if(_executions_json_ != nil) {
            for(int i=0; i<_executions_json_.count; i++) {
                NSDictionary *_execution_json_ = [_executions_json_ objectAtIndex:i];
                for(int j=0; j<self.timingTaskExecutionItems.count; j++) {
                    TimingTaskExecutionItem *item = [self.timingTaskExecutionItems objectAtIndex:j];
                    if([item.deviceIdentifier isEqualToString:[_execution_json_ noNilStringForKey:@"code"]]) {
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

        NSLog(@"is -------  %d   %d   %d", dc.weekday, dc.hour, dc.minute);
        
        self.unitIdentifier = _unit_.identifier;
        self.name = NSLocalizedString(@"timing_tasks_plan_default_name", @"");
        self.enable = YES;
        self.scheduleMode = TaskScheduleModeNoRepeat;
        self.scheduleDate = TaskScheduleDateMonday | TaskScheduleDateTuesday;
        self.scheduleTimeHour = dc.hour;
        self.scheduleTimeMinute = dc.minute;
        
        for(int i=0; i<_unit_.devices.count; i++) {
            Device *device = [_unit_.devices objectAtIndex:i];
            if(device.isAirPurifier) {
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
    
    
    
    
    
    return json;
}

- (NSString *)stringForScheduleDate {
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