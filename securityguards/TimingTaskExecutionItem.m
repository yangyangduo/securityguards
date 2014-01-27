//
//  TimingTaskExecutionItem.m
//  securityguards
//
//  Created by Zhao yang on 1/26/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTaskExecutionItem.h"

@implementation TimingTaskExecutionItem

@synthesize deviceIdentifier;
@synthesize executionCommandString;
@synthesize status;
@synthesize device;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.status = DEFAULT_STATUS;
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.deviceIdentifier = [json noNilStringForKey:@"code"];
        self.executionCommandString = [json noNilStringForKey:@"cmd"];
        self.status = [json intForKey:@"status"];
    }
    return self;
}

- (void)updateWithJson:(NSDictionary *)json {
    if([XXStringUtils isBlank:self.deviceIdentifier]) return;
    
    NSString *code = [json noNilStringForKey:@"code"];
    if([XXStringUtils isBlank:code] || ![code isEqualToString:self.deviceIdentifier]) {
        return;
    }
    
    self.status = [json intForKey:@"status"];
    self.executionCommandString = [json noNilStringForKey:@"cmd"];
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    [json setInteger:self.status forKey:@"status"];
    [json setMayBlankString:self.deviceIdentifier forKey:@"code"];
    [json setMayBlankString:executionCommandString forKey:@"cmd"];
    
    return json;
}

- (BOOL)isAvailableItem {
    return DEFAULT_STATUS != self.status;
}

@end
