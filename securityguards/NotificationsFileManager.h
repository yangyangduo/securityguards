//
//  NotificationsFileManager.h
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"

@interface NotificationsFileManager : NSObject

- (NSArray *)readFromDisk;
- (void)writeToDisk:(NSArray *)messages;
- (void)update:(NSArray *)modifyList deleteList:(NSArray *)deleteList;

+ (NotificationsFileManager *)fileManager;

@end
