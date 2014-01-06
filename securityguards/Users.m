//
//  Users.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Users.h"

@implementation Users

@synthesize users = _users_;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        NSArray *_users = [json arrayForKey:@"users"];
        if(_users != nil) {
            for(int i=0; i<_users.count; i++) {
                NSDictionary *_user = [_users objectAtIndex:i];
                if(_user != nil) {
                    [self.users addObject:[[User alloc] initWithJson:_user]];
                }
            }
        }
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    return json;
}

- (User *)userWithId:(NSString *)identifier {
    if([XXStringUtils isBlank:identifier]) return nil;
    for(int i=0; i<self.users.count; i++) {
        User *user = [self.users objectAtIndex:i];
        if([identifier isEqualToString:user.identifier]) {
            return user;
        }
    }
    return nil;
}

- (User *)userWithMobile:(NSString *)mobile {
    if([XXStringUtils isBlank:mobile]) return nil;
    for(int i=0; i<self.users.count; i++) {
        User *user = [self.users objectAtIndex:i];
        if([mobile isEqualToString:user.mobile]) {
            return user;
        }
    }
    return nil;
}

- (NSMutableArray *)users {
    if(_users_ == nil) {
        _users_ = [NSMutableArray array];
    }
    return _users_;
}

- (NSUInteger)count {
    return self.users.count;
}

@end
