//
//  Shared.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Shared.h"

@implementation Shared

+ (instancetype)shared {
    static Shared *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    return shared;
}

- (AppDelegate *)app {
    return [UIApplication sharedApplication].delegate;
}

@end
