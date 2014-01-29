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

- (id)copy {
    TimingTaskExecutionItem *nself = [[TimingTaskExecutionItem alloc] init];
    nself.deviceIdentifier = self.deviceIdentifier;
    nself.executionCommandString = self.executionCommandString;
    nself.status = self.status;
    nself.device = self.device;
    return nself;
}

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
        self.deviceIdentifier = [json noNilStringForKey:@"cd"];
        self.executionCommandString = [json noNilStringForKey:@"cm"];
        self.status = [json intForKey:@"st"];
    }
    return self;
}

- (void)updateWithJson:(NSDictionary *)json {
    if([XXStringUtils isBlank:self.deviceIdentifier]) return;
    
    NSString *code = [json noNilStringForKey:@"cd"];
    if([XXStringUtils isBlank:code] || ![code isEqualToString:self.deviceIdentifier]) {
        return;
    }
    
    self.status = [json intForKey:@"st"];
    self.executionCommandString = [json noNilStringForKey:@"cm"];
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    [json setInteger:self.status forKey:@"st"];
    [json setMayBlankString:self.deviceIdentifier forKey:@"cd"];
    [json setMayBlankString:executionCommandString forKey:@"cm"];
    
    return json;
}

- (BOOL)isAvailableItem {
    return DEFAULT_STATUS != self.status;
}

@end
