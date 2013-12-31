//
//  XXDateFormatter.m
//  securityguards
//
//  Created by hadoop user account on 31/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXDateFormatter.h"
#import "XXStringUtils.h"

@implementation XXDateFormatter

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
