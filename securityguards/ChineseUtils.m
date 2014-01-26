//
//  ChineseUtils.m
//  securityguards
//
//  Created by Zhao yang on 1/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ChineseUtils.h"

@implementation ChineseUtils

+ (NSString *)chineseWeekForInt:(int)number {
    switch (number) {
        case 1:
            return @"一";
        case 2:
            return @"二";
        case 3:
            return @"三";
        case 4:
            return @"四";
        case 5:
            return @"五";
        case 6:
            return @"六";
        case 7:
            return @"日";
    }
    return @"";
}

@end
