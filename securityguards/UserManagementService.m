//
//  UserManagementService.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserManagementService.h"
#import "GlobalSettings.h"

@implementation UserManagementService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/mgr/acc", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

- (void)usersForUnit:(NSString *)unitIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/list/%@?deviceCode=%@&appKey=%@&security=%@", unitIdentifier, [GlobalSettings defaultSettings].deviceCode, APP_KEY, [GlobalSettings defaultSettings].secretKey];
    NSLog(@"userservice request url:%@",url);
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)unBindUnit:(NSString *)unitIdentifier forUser:(NSString *)userIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/unbind/%@/%@?deviceCode=%@&appKey=%@&security=%@", unitIdentifier, userIdentifier, [GlobalSettings defaultSettings].deviceCode, APP_KEY, [GlobalSettings defaultSettings].secretKey];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

@end
