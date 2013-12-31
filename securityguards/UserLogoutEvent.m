//
//  UserLogoutEvent.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserLogoutEvent.h"

@implementation UserLogoutEvent

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventUserLogout;
    }
    return self;
}

@end
