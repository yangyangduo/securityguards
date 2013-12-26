//
//  SMDateFormatter.h
//  SmartHome
//
//  Created by Zhao yang on 9/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDateFormatter : NSObject

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format;

@end
