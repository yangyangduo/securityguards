//
//  CommandQueue.m
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CommandQueue.h"

#define CLEARD_COMMANDS_CAPS 50
#define COMMANDS_CLEARD_TO   20

@implementation CommandQueue {
    NSMutableArray *queue;
}

- (id)init {
    self = [super init];
    if(self) {
        queue = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)count {
    @synchronized(self) {
        return queue.count;
    }
}

- (void)pushCommand:(DeviceCommand *)command {
    @synchronized(self) {
        if(queue.count >= CLEARD_COMMANDS_CAPS) {
            [self clearUpInternal];
        }
        [queue addObject:command];
    }
}

- (BOOL)contains:(DeviceCommand *)command {
    @synchronized(self) {
        if(queue == nil || queue.count == 0) return NO;
        for(DeviceCommand *cmd in queue) {
            if([cmd isEqual:command]) {
                return YES;
            }
        }
        return NO;
    }
}

- (DeviceCommand *)popup {
    @synchronized(self) {
        if(queue.count > 0) {
            DeviceCommand *command = [queue objectAtIndex:0];
            if(command != nil) {
                [queue removeObjectAtIndex:0];
                return command;
            }
        }
        return nil;
    }
}

- (void)clearUpInternal {
#ifdef DEBUG
    NSLog(@"[COMMAND QUEUE] Too many commands has been queued, clear some older commands ...");
#endif
    [queue removeObjectsInRange:NSMakeRange(0, queue.count - COMMANDS_CLEARD_TO)];
}

@end
