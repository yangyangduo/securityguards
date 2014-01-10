//
//  NewsFileManager.h
//  securityguards
//
//  Created by Zhao yang on 1/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFileManager : NSObject

- (void)saveToDisk:(NSArray *)newsToSave lastUpdateTime:(NSDate *)lastUpdateTime;
- (NSArray *)readFromDisk:(NSDate **)lastUpdateTime;
+ (NewsFileManager *)fileManager;

@end
