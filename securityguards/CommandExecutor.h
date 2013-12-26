//
//  CommandExecutor.h
//  SmartHome
//
//  Created by Zhao yang on 9/25/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"

@protocol CommandExecutor <NSObject>

- (void)executeCommand:(DeviceCommand *)command;
- (NSString *)executorName;

@optional

- (void)queueCommand:(DeviceCommand *)command;

@end
