//
//  GlobalSettings.m
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "GlobalSettings.h"
#import "XXStringUtils.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

#define GLOBAL_SETTINGS_KEY                      @"global_settings.key"
#define ACCOUNT_KEY                              @"account.key"
#define SECRET_KEY_KEY                           @"secret_key.key"
#define TCP_ADDRESS_KEY                          @"tcp_address.key"
#define DEVICE_CODE_KEY                          @"device_code.key"
#define IS_VOICE_KEY                             @"is_voice.key"
#define IS_SHAKE_KEY                             @"is_shake.key"
#define DEVICE_TOKEN_KEY                         @"device_token.key"
#define REST_ADDRESS_KEY                         @"rest_address.key"
#define GET_UNITS_COMMAND_LAST_EXECUTE_DATE      @"g_u_c_l_e_d.key"

@implementation GlobalSettings

@synthesize account;
@synthesize secretKey;
@synthesize deviceCode;
@synthesize deviceToken;
@synthesize tcpAddress;
@synthesize restAddress;
@synthesize isShake;
@synthesize isVoice;

@synthesize getUnitsCommandLastExecuteDate;

+ (instancetype)defaultSettings {
    static GlobalSettings *settings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[[self class] alloc] init];
    });
    return settings;
}

- (id)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *settings = [defaults objectForKey:GLOBAL_SETTINGS_KEY];
        if(settings == nil) {
            //no settings file before
            self.account = [XXStringUtils emptyString];
            self.secretKey = [XXStringUtils emptyString];
            self.tcpAddress = [XXStringUtils emptyString];
            self.deviceCode = [XXStringUtils emptyString];
            self.restAddress = [XXStringUtils emptyString];
            self.deviceToken = [XXStringUtils emptyString];
            self.getUnitsCommandLastExecuteDate = nil;
            self.isVoice = YES;
            self.isShake = NO;
        } else {
            //already have a setting file
            //need to fill object property
            self.account = [settings noNilStringForKey:ACCOUNT_KEY];
            self.secretKey = [settings noNilStringForKey:SECRET_KEY_KEY];
            self.tcpAddress = [settings noNilStringForKey:TCP_ADDRESS_KEY];
            self.deviceCode = [settings noNilStringForKey:DEVICE_CODE_KEY];
            self.isShake = [settings boolForKey:IS_SHAKE_KEY];
            self.isVoice = [settings boolForKey:IS_VOICE_KEY];
            self.deviceToken = [settings noNilStringForKey:DEVICE_TOKEN_KEY];
            self.restAddress = [settings noNilStringForKey:REST_ADDRESS_KEY];
            self.getUnitsCommandLastExecuteDate = [settings dateWithTimeIntervalSince1970ForKey:GET_UNITS_COMMAND_LAST_EXECUTE_DATE];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    //convert self to a dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setMayBlankString:self.account forKey:ACCOUNT_KEY];
    [dictionary setMayBlankString:self.secretKey forKey:SECRET_KEY_KEY];
    [dictionary setMayBlankString:self.deviceToken forKey:DEVICE_TOKEN_KEY];
    [dictionary setMayBlankString:self.tcpAddress forKey:TCP_ADDRESS_KEY];
    [dictionary setMayBlankString:self.deviceCode forKey:DEVICE_CODE_KEY];
    [dictionary setMayBlankString:self.restAddress forKey:REST_ADDRESS_KEY];
    if(self.getUnitsCommandLastExecuteDate != nil) {
        [dictionary setDateUsingTimeIntervalSince1970:self.getUnitsCommandLastExecuteDate forKey:GET_UNITS_COMMAND_LAST_EXECUTE_DATE];
    }
    [dictionary setBool:self.isShake forKey:IS_SHAKE_KEY];
    [dictionary setBool:self.isVoice forKey:IS_VOICE_KEY];
    return dictionary;
}

- (void)saveSettingsInternal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:GLOBAL_SETTINGS_KEY];
    [defaults synchronize];
}

- (void)clearAuth {
    @synchronized(self) {
        self.secretKey = [XXStringUtils emptyString];
        self.account = [XXStringUtils emptyString];
        self.deviceCode = [XXStringUtils emptyString];
        self.deviceToken = [XXStringUtils emptyString];
        [self saveSettingsInternal];
    }
}

- (void)saveSettings {
    @synchronized(self) {
        [self saveSettingsInternal];
    }
}

- (BOOL)hasLogin {
    if(![XXStringUtils isBlank:[GlobalSettings defaultSettings].secretKey]
       && ![XXStringUtils isBlank:[GlobalSettings defaultSettings].deviceCode]) {
        return YES;
    }
    return NO;
}

@end
