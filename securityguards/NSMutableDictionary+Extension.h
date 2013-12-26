//
//  NSMutableDictionary+Extension.h
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXStringUtils.h"

@interface NSMutableDictionary (Extension)

- (void)setInteger:(NSInteger)integer forKey:(id<NSCopying>)key;
- (void)setDouble:(double)db forKey:(id<NSCopying>)key;
- (void)setDateLongLongValue:(NSDate *)date forKey:(id<NSCopying>)key;
- (void)setNoNilObject:(id)object forKey:(id<NSCopying>)key;
- (void)setNoBlankString:(NSString *)string forKey:(id<NSCopying>)key;
- (void)setBool:(BOOL)b forKey:(id<NSCopying>)key;
- (void)setMayBlankString:(NSString *)string forKey:(id<NSCopying>)key;

@end
