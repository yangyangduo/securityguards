//
//  XXDateFormatter.h
//  securityguards
//
//  Created by hadoop user account on 31/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDateFormatter : NSObject
+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format;
@end
