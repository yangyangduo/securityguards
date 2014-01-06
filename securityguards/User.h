//
//  User.h
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Entity.h"

typedef NS_ENUM(NSUInteger, UserState) {
    UserStateUnknow,
    UserStateOnline,
    UserStateOffline
};

@interface User : Entity

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL isOwner;
@property (assign, nonatomic, readonly) BOOL isCurrentUser;
@property (assign, nonatomic) UserState userState;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic, readonly) NSString *stringForUserState;

@end
