//
//  Shared.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Shared.h"

@implementation Shared

+ (Shared *)shared {
    static Shared *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[Shared alloc] init];
    });
    return shared;
}

- (AppDelegate *)app {
    return [UIApplication sharedApplication].delegate;
}

@end
