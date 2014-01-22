//
//  NotificationsFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsFileManager.h"
#import "SMNotification.h"
#import "GlobalSettings.h"

#define MAX_NOTIFICATIONS_COUNT 50

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"familyguards-notifications"]

@implementation NotificationsFileManager


+ (NotificationsFileManager *)fileManager {
    static NotificationsFileManager *manager;
    static dispatch_once_t notificationOnceToken;
    dispatch_once(&notificationOnceToken, ^{
        manager = [[NotificationsFileManager alloc] init];
    });
    return manager;
}

- (NSArray *)readFromDisk {
    @synchronized(self) {
        return [self readFromDiskInternal];
    }
}

- (NSArray *)readFromDiskInternal {
    NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [GlobalSettings defaultSettings].account]];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(exists) {
        NSMutableArray *notifications = [NSMutableArray array];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
        if(json != nil) {
            NSArray *_notifications_ = [json notNSNullObjectForKey:@"notifications"];
            if(_notifications_ != nil) {
                for(NSDictionary *js in _notifications_) {
                    [notifications addObject:[[SMNotification alloc] initWithJson:js]];
                }
                return notifications;
            }
        }
    } else {
#ifdef DEBUG
        NSLog(@"[NOTIFICATION FILE MANAGER] Notifications file not exists");
#endif
    }
    return nil;
}

- (void)update:(NSArray *)modifyList deleteList:(NSArray *)deleteList {
    @synchronized(self) {
        @try {
            if((modifyList == nil || modifyList.count == 0) && (deleteList == nil || deleteList.count == 0)) {
                return;
            }
            NSArray *oldNotifications = [self readFromDiskInternal];
            if(oldNotifications == nil || oldNotifications.count == 0) return;
            
            NSMutableArray *newList = [NSMutableArray array];
            
            if(deleteList != nil && deleteList.count != 0) {
                for(SMNotification *oldItem in oldNotifications) {
                    BOOL needDelete = NO;
                    for(SMNotification *delItem in deleteList) {
                        if([oldItem.identifier isEqualToString:delItem.identifier]) {
                            needDelete = YES;
                            break;
                        }
                    }
                    if(!needDelete) {
                        [newList addObject:oldItem];
                    }
                }
            } else {
                [newList addObjectsFromArray:oldNotifications];
            }

            if(modifyList != nil && modifyList.count != 0) {
                for(SMNotification *modifyItem in modifyList) {
                    for(SMNotification *oldItem in newList) {
                        if([modifyItem.identifier isEqualToString:oldItem.identifier]) {
                            oldItem.hasRead = modifyItem.hasRead;
                            oldItem.hasProcess = modifyItem.hasProcess;
                            oldItem.text = modifyItem.text;
                            break;
                        }
                    }
                }
            }
            
            [self saveToDiskInternal:newList];
        }
        @catch (NSException *exception) {
#ifdef DEBUG
            NSLog(@"[NOTIFICATION FILE MANAGER] Exception in update notifications to disk >>> %@", exception.reason);
#endif
        }
        @finally {

        }
    }
}

- (void)saveToDiskInternal:(NSArray *)notificationsToSave {
    
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
    if(!directoryExists) {
        NSError *error;
        BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
        if(!createDirSuccess) {
#ifdef DEBUG
            NSLog(@"[NOTIFICATION FILE MANAGER] Create directory failed , error >>> %@", error.description);
#endif
            return;
        }
    }
    
    NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [GlobalSettings defaultSettings].account]];
    
    //
    NSMutableArray *_notifications_ = [NSMutableArray array];
    for(int i=0; i<notificationsToSave.count; i++) {
        SMNotification *smn = [notificationsToSave objectAtIndex:i];
        if(smn != nil) {
            [_notifications_ addObject:[smn toJson]];
        }
    }
    
    NSData *data = [JsonUtils createJsonDataFromDictionary:[NSDictionary dictionaryWithObject:_notifications_ forKey:@"notifications"]];
    
    BOOL success = [data writeToFile:filePath atomically:YES];
    
    if(!success) {
#ifdef DEBUG
        NSLog(@"[NOTIFICATION FILE MANAGER] Save notifications failed ...");
#endif
    }
}

- (void)writeToDisk:(NSArray *)newNotifications {
    @synchronized(self) {
        @try {
            if(newNotifications == nil || newNotifications.count == 0) {
                return;
            }
            
            // save list
            NSMutableArray *notificationsToSave = [NSMutableArray array];
            
            // old notifications
            NSArray *oldNotifications = [self readFromDiskInternal];
            
            // 以前没有消息, 新消息全部存入
            if(oldNotifications == nil || oldNotifications.count == 0) {
                [notificationsToSave addObjectsFromArray:newNotifications];
            } else {
                // 新消息和老消息总数小于50条, 新老消息都可全部存入
                if(oldNotifications.count + newNotifications.count <= MAX_NOTIFICATIONS_COUNT) {
                    [notificationsToSave addObjectsFromArray:oldNotifications];
                    [notificationsToSave addObjectsFromArray:newNotifications];
                } else {
                    // 新消息总数大于50条,只存新消息和老的未读消息
                    if(newNotifications.count >= MAX_NOTIFICATIONS_COUNT) {
                        
                        for(SMNotification *noti in oldNotifications) {
                            if(!noti.hasRead) {
                                [notificationsToSave addObject:noti];
                            }
                        }
                        
                        [notificationsToSave addObjectsFromArray:newNotifications];
                    } else {
                        int hasReadCount = 0;
                        for(SMNotification *noti in oldNotifications) {
                            if(noti.hasRead) {
                                hasReadCount++;
                            }
                        }
                        // 新消息加未读消息大于50条,老的已读消息全删
                        if(hasReadCount >= MAX_NOTIFICATIONS_COUNT) {
                            for(SMNotification *noti in oldNotifications) {
                                if(!noti.hasRead) {
                                    [notificationsToSave addObject:noti];
                                }
                            }
                            [notificationsToSave addObjectsFromArray:newNotifications];
                        } else {
                            // 需要删除的已读老消息数量
                            NSInteger hasReadedNeedToDelCount = oldNotifications.count -  (MAX_NOTIFICATIONS_COUNT - hasReadCount - newNotifications.count);
                            
                            int deletedCount = 0;
                            for(SMNotification *noti in oldNotifications) {
                                if(noti.hasRead && deletedCount < hasReadedNeedToDelCount) {
                                    deletedCount++;
                                    continue;
                                }
                                [notificationsToSave addObject:noti];
                            }
                            [notificationsToSave addObjectsFromArray:newNotifications];
                        }
                    }
                }
            }
            [self saveToDiskInternal:notificationsToSave];
        }
        @catch (NSException *exception) {
#ifdef DEBUG
            NSLog(@"[NOTIFICATION FILE MANAGER] exception in save notifications to disk >>> %@", exception.reason);
#endif
        }
        @finally {

        }
    }
}

@end
