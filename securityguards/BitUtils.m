//
//  BitUtils.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BitUtils.h"

@implementation BitUtils

+ (void)int2Bytes:(NSUInteger)number bytes:(uint8_t *)bytes {
    bytes[0] = number & 0xff;
    bytes[1] = number >> 8  & 0xff;
    bytes[2] = number >> 16 & 0xff;
    bytes[3] = number >> 24 & 0xff;
}

+ (NSUInteger)bytes2Int:(uint8_t *)bytes {
    return (bytes[0] & 0xff) | (bytes[1] & 0xff) << 8 | (bytes[2] & 0xff) << 16 | (bytes[3] & 0xff) << 24;
}

+ (NSUInteger)bytes2Int:(uint8_t *)bytes range:(NSRange)range {
    return (bytes[range.location] & 0xff) | (bytes[range.location + 1] & 0xff) << 8 | (bytes[range.location + 2] & 0xff) << 16 | (bytes[range.location + 3] & 0xff) << 24;
}

@end
