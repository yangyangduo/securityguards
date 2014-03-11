//
//  NewsFileManager.m
//  securityguards
//
//  Created by Zhao yang on 1/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewsFileManager.h"
#import "JsonUtils.h"
#import "News.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"familyguards-news"]

@implementation NewsFileManager

+ (NewsFileManager *)fileManager {
    static NewsFileManager *manager;
    static dispatch_once_t newsOnceToken;
    dispatch_once(&newsOnceToken, ^{
        manager = [[NewsFileManager alloc] init];
    });
    return manager;
}

- (NSArray *)readFromDisk:(NSDate **)lastUpdateTime {
    @synchronized(self) {
        return [self readFromDiskInternal:lastUpdateTime];
    }
}

- (NSArray *)readFromDiskInternal:(NSDate **)lastUpdateTime {
    NSString *filePath = [DIRECTORY stringByAppendingPathComponent:@"news.txt"];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(exists) {
        NSMutableArray *allNews = [NSMutableArray array];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
        if(json != nil) {
            NSDate *date = [json dateWithMillisecondsForKey:@"lastUpdateTime"];
            if(date != nil) {
                *lastUpdateTime = date;
            }
            NSArray *_news_ = [json notNSNullObjectForKey:@"news"];
            if(_news_ != nil) {
                for(NSDictionary *js in _news_) {
                    [allNews addObject:[[News alloc] initWithJson:js]];
                }
                return allNews;
            }
        }
    } else {
#ifdef DEBUG
        NSLog(@"[NEWS FILE MANAGER] News file not exists");
#endif
    }
    return nil;
}

- (void)saveToDisk:(NSArray *)newsToSave lastUpdateTime:(NSDate *)lastUpdateTime {
    @synchronized(self) {
        BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
        if(!directoryExists) {
            NSError *error;
            BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
            if(!createDirSuccess) {
#ifdef DEBUG
                NSLog(@"[NEWS FILE MANAGER] Create directory failed , error >>> %@", error.description);
#endif
                return;
            }
        }
        
        NSString *filePath = [DIRECTORY stringByAppendingPathComponent:@"news.txt"];
        
        //
        NSMutableArray *_news_ = [NSMutableArray array];
        for(int i=0; i<newsToSave.count; i++) {
            News *news = [newsToSave objectAtIndex:i];
            [_news_ addObject:[news toJson]];
        }
        
        NSMutableDictionary *json = [NSMutableDictionary dictionary];
        [json setObject:_news_ forKey:@"news"];
        [json setDateWithMilliseconds:lastUpdateTime forKey:@"lastUpdateTime"];
        
        NSData *data = [JsonUtils createJsonDataFromDictionary:json];
        
        BOOL success = [data writeToFile:filePath atomically:YES];
        
        if(!success) {
#ifdef DEBUG
            NSLog(@"[NEWS FILE MANAGER] Save news failed ...");
#endif
        }
    }
}

@end
