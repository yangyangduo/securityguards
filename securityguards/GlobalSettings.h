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

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSString *deviceCode;
@property (strong, atomic)    NSString *tcpAddress;
@property (strong, nonatomic) NSString *restAddress;
@property (assign, nonatomic) BOOL isVoice;
@property (assign, nonatomic) BOOL isShake;
@property (strong, nonatomic) NSString *deviceToken;

+ (GlobalSettings *)defaultSettings;

- (NSDictionary *)toDictionary;
- (void)saveSettings;
- (void)clearAuth;

@end
