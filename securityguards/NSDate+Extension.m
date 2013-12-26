//
//  NSDate+Extension.m
//  SmartHome
//
//  Created by Zhao yang on 9/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (id)dateWithTimeIntervalMillisecondSince1970:(NSTimeInterval)time {
    return [NSDate dateWithTimeIntervalSince1970:time / 1000];
}

@end
