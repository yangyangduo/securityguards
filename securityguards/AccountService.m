//
//  AccountService.m
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountService.h"
#import "XXStringUtils.h"

#define AUTH_URL @"http://www.hentre.com:6868/FrontServer-1.0/auth"
//#define AUTH_URL @"http://hentre.f3322.org:6868/FrontServer-1.0/auth"

static const NSString *MD5_KEY = @"FFFF";

@implementation AccountService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:AUTH_URL];
    }
    return self;
}

- (void)sendVerificationCodeFor:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *checkCode = [XXStringUtils md5HexDigest:[NSString stringWithFormat:@"%@%@", phoneNumber, MD5_KEY]];
    NSString *url = [NSString stringWithFormat:@"/regist?mobileCode=%@&checkCode=%@&appKey=%@", phoneNumber, checkCode,APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)sendModifyUsernameVerificationCodeFor:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb{
    NSString *checkCode = [XXStringUtils md5HexDigest:[NSString stringWithFormat:@"%@%@", phoneNumber, MD5_KEY]];
    NSString *url = [NSString stringWithFormat:@"/modify/phone/check?mobileCode=%@&checkCode=%@&appKey=%@", phoneNumber, checkCode,APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];

}
- (void)registerWithPhoneNumber:(NSString *)phoneNumber checkCode:(NSString *)checkCode success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/regist/confirm?mobileCode=%@&checkCode=%@&phoneType=%@&mac=%@&appKey=%@", phoneNumber, checkCode, PHONE_TYPE, phoneNumber, APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/login?mobileCode=%@&pwd=%@&appKey=%@&phoneType=%@",account, pwd,APP_KEY, PHONE_TYPE];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)sendPasswordToMobile:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/forget/pwd?mobileCode=%@&checkCode=%@&appKey=%@", phoneNumber, [XXStringUtils md5HexDigest:[NSString stringWithFormat:@"%@FFFF", phoneNumber]],APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)modifyUsernameByPhoneNumber:(NSString *)phoneNumber checkCode:(NSString *)checkCode oldPassword:(NSString *)password success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb{
    NSString *url = [NSString stringWithFormat:@"/modify/phone?id=%@&pwd=%@&mobile=%@&checkCode=%@&appKey=%@",[GlobalSettings defaultSettings].deviceCode,password, phoneNumber,checkCode,APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)relogin:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/login/reLogin?deviceCode=%@&securityKey=%@&appKey=%@", [GlobalSettings defaultSettings].deviceCode, [GlobalSettings defaultSettings].secretKey, APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

@end
