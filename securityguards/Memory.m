//
//  Memory.m
//  securityguards
//
//  Created by Zhao yang on 2/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Memory.h"

@implementation Memory {
}

@synthesize userInfo = _userInfo_;
@synthesize merchandises;

+ (instancetype)memory {
    static Memory *memory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        memory = [[Memory alloc] init];
    });
    return memory;
}

- (id)init {
    self = [super init];
    if(self) {
        self.userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearAll {
    //
}

@end
