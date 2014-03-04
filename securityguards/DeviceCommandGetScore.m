//
// Created by Zhao yang on 3/4/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceCommandGetScore.h"
#import "CommandFactory.h"

@implementation DeviceCommandGetScore {

}

@synthesize score;
@synthesize rankings;
@synthesize scoreTime;

- (id)init {
    self = [super init];
    if(self) {
       self.commandName = COMMAND_GET_SCORE;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self && json) {
        self.commandName = COMMAND_GET_SCORE;
        self.score = [json intForKey:@"score"];
        self.rankings = [json intForKey:@"rankings"];
        self.scoreTime = [NSDate dateWithTimeIntervalSince1970:[json doubleForKey:@"scoreTime"] / 1000];
    }
    return self;
}

@end