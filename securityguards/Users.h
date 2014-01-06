//
//  Users.h
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Entity.h"
#import "User.h"

@interface Users : Entity

@property (strong, nonatomic) NSMutableArray *users;
@property (assign, nonatomic, readonly) NSUInteger count;

- (User *)userWithId:(NSString *)identifier;
- (User *)userWithMobile:(NSString *)mobile;

@end
