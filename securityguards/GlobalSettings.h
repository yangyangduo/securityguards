//
//  GlobalSettings.h
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_KEY     @"A002"
#define PHONE_TYPE  @"IOS"

@interface GlobalSettings : NSObject

@property (nonatomic) BOOL isVoice;
@property (nonatomic) BOOL isShake;
@property (strong)    NSString *tcpAddress;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *deviceCode;
@property (nonatomic, strong) NSString *restAddress;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, readonly, getter = hasLogin) BOOL login;

+ (GlobalSettings *)defaultSettings;

- (NSDictionary *)toDictionary;
- (void)saveSettings;
- (void)clearAuth;

@end
