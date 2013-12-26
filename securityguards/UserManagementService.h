//
//  UserManagementService.h
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"

@interface UserManagementService : ServiceBase

- (void)usersForUnit:(NSString *)unitIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)unBindUnit:(NSString *)unitIdentifier forUser:(NSString *)userIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

@end
