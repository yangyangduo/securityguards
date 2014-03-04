//
// Created by Zhao yang on 3/4/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "ScoreChangedEvent.h"

@implementation ScoreChangedEvent {

}

@synthesize score;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventScoreChanged;
    }
    return self;
}

@end