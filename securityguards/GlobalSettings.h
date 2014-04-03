//
//  GlobalSettings.h
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecurityGuards.h"


@interface GlobalSettings : NSObject

@property (nonatomic) BOOL isVoice;
@property (nonatomic) BOOL isShake;
@property (nonatomic, strong) NSString *tcpAddress;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *deviceCode;
@property (nonatomic, strong) NSString *restAddress;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, readonly, getter = hasLogin) BOOL login;

+ (instancetype)defaultSettings;

- (NSDictionary *)toDictionary;
- (void)saveSettings;
- (void)clearAuth;

@end
