//
//  MyOperation.m
//  securityguards
//
//  Created by Zhao yang on 1/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

//- (void)start {
//    BOOL isMainThread = [NSThread currentThread].isMainThread;
//    NSLog(@"%@", isMainThread ? @"is main thread" : @"isn't main thread");
//}

- (void)main {
    BOOL isMainThread = [NSThread currentThread].isMainThread;
    NSLog(@"%@", isMainThread ? @"is main thread" : @"isn't main thread");
}

//- (BOOL)isConcurrent {
//    return YES;
//}

@end
