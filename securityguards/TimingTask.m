//
//  TimingTasks.m
//  securityguards
//
//  Created by Zhao yang on 1/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTask.h"
#import "ChineseUtils.h"

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

@synthesize name;
@synthesize scheduleDate;
@synthesize scheduleTimeHour;
@synthesize scheduleTimeMinute;
@synthesize scheduleMode;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        // set name
        self.name = [json noNilStringForKey:@"name"];
        
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
        
        // set executions
        NSArray *_executions_json_ = [json arrayForKey:@"executions"];
        if(_executions_json_ != nil) {
            
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
    
    for(int i=0; i<7; i++) {
        if((self.scheduleDate & (1 << i)) == (1 << i)) {
            [ms appendString:[ChineseUtils chineseWeekForInt:(i + 1)]];
        }
    }
    
    return ms;
}

@end