//
//  DeviceUtils.h
//  securityguards
//
//  Created by Zhao yang on 1/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "DeviceOperationItem.h"

@interface DeviceUtils : NSObject

+ (NSString *)statusAsStringFor:(Device *)device;
+ (NSString *)statusAsStringFor:(Device *)device status:(int)status;

+ (NSString *)stateAsString:(int)state;

+ (NSMutableArray *)operationsListFor:(Device *)device;
+ (void)executeOperationItem:(DeviceOperationItem *)operationItem;

@end
