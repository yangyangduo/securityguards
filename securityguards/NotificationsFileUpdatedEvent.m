//
//  NotificationsFileUpdatedEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsFileUpdatedEvent.h"

@implementation NotificationsFileUpdatedEvent

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventNotificationsFileUpdated;
    }
    return self;
}

@end
