//
//  DeviceCommandUpdateNotifications.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateNotifications.h"

@implementation DeviceCommandUpdateNotifications

@synthesize notifications = _notifications;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        if(json) {
            NSArray *_notifications_ = [json arrayForKey:@"mqs"];
            if(_notifications_ != nil) {
                for(int i=0; i<_notifications_.count; i++) {
                    NSDictionary *_notification_ = [_notifications_ objectAtIndex:i];
                    if(_notification_ != nil) {
                        [self.notifications addObject:[[SMNotification alloc] initWithJson:_notification_]];
                    }
                }
            }
            
            NSDictionary *_notification = [json dictionaryForKey:@"mq"];
            if(_notification != nil) {
                [self.notifications addObject:[[SMNotification alloc] initWithJson:_notification]];
            }
        }
    }
    return self;
}

- (NSMutableArray *)notifications {
    if(_notifications == nil) {
        _notifications = [NSMutableArray array];
    }
    return _notifications;
}

@end
