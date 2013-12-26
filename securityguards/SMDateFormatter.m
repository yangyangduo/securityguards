//
//  SMDateFormatter.m
//  SmartHome
//
//  Created by Zhao yang on 9/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMDateFormatter.h"
#import "XXStringUtils.h"

@implementation SMDateFormatter

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format {
    if(date == nil || [XXStringUtils isBlank:format]) return [XXStringUtils emptyString];
    NSDateFormatter *formatter = [self formatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSDateFormatter *)formatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    return formatter;
}

@end
