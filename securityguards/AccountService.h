//
//  AccountService.h
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"

@interface AccountService : ServiceBase

- (void)sendVerificationCodeFor:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)sendModifyUsernameVerificationCodeFor:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)registerWithPhoneNumber:(NSString *)phoneNumber checkCode:(NSString *)checkCode success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)sendPasswordToMobile:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)modifyUsernameByPhoneNumber:(NSString *) phoneNumber checkCode:(NSString *) checkCode oldPassword:(NSString *) password success:(SEL) s failed:(SEL) f target:(id)t callback:(id) cb;

- (void)relogin:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)regWithMobile:(NSString *)mobile pwd:(NSString *)pwd checkCode:(NSString *)checkCode success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

@end
