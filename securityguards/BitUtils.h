//
//  BitUtils.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitUtils : NSObject

+ (NSUInteger)bytes2Int:(uint8_t *)bytes;
+ (void)int2Bytes:(NSUInteger)number bytes:(uint8_t *)bytes;
+ (NSUInteger)bytes2Int:(uint8_t *)bytes range:(NSRange)range;

@end
