//
//  Device.m
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Device.h"

int const kDeviceStateIgnore                              =    999;

int const kDeviceStateClose                               =    0;
int const kDeviceStateOpen                                =    1;

int const kDeviceAirPurifierLevelHigh                     =    2;
int const kDeviceAirPurifierLevelMedium                   =    1;
int const kDeviceAirPurifierLevelLow                      =    0;

int const kDeviceSecurityClose                            =    0;
int const kDeviceSecurityOpen                             =    1;

int const kDeviceAirPurifierControlModeAutomatic          =    0;
int const kDeviceAirPurifierControlModeManual             =    1;
int const kDeviceAirPurifierControlModeSleepOrWakeUp      =    2;

@implementation Device

@synthesize zone;

@synthesize category;
@synthesize ep;
@synthesize identifier;
@synthesize ip;
@synthesize irType;
@synthesize state;
@synthesize status;
@synthesize port;
@synthesize pwd;
@synthesize resolution;
@synthesize type;
@synthesize name;
@synthesize nwkAddr;
@synthesize user;
@synthesize isWarsignal;

@synthesize isRemote;
@synthesize isSccurtain;
@synthesize isCurtain;
@synthesize isInlight;
@synthesize isLightOrInlight;
@synthesize isAircondition;
@synthesize isCurtainOrSccurtain;
@synthesize isLight;
@synthesize isSocket;
@synthesize isSTB;
@synthesize isTV;
@synthesize isCamera;
@synthesize isBackgroundMusic;
@synthesize isDVD;

@synthesize isSensor;

@synthesize isOnline;
@synthesize isAvailableDevice;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.category = [json stringForKey:@"category"];
            self.ep = [json intForKey:@"ep"];
            self.identifier = [json stringForKey:@"code"];
            self.ip = [json stringForKey:@"ip"];
            self.irType = [json intForKey:@"irType"];
            self.status = [json intForKey:@"status"];
            self.state = [json intForKey:@"state"];
            self.port = [json intForKey:@"port"];
            self.pwd = [json stringForKey:@"pwd"];
            self.resolution = [json intForKey:@"resolution"];
            self.type = [json intForKey:@"type"];
            self.name = [json stringForKey:@"name"];
            self.nwkAddr = [json stringForKey:@"nwkAddr"];
            self.user = [json stringForKey:@"user"];
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setMayBlankString:self.category forKey:@"category"];
    [json setInteger:self.ep forKey:@"ep"];
    [json setMayBlankString:self.identifier forKey:@"code"];
    [json setMayBlankString:self.ip forKey:@"ip"];
    [json setInteger:self.irType forKey:@"irType"];
    [json setInteger:self.status forKey:@"status"];
    [json setInteger:self.state forKey:@"state"];
    [json setInteger:self.port forKey:@"port"];
    [json setMayBlankString:self.pwd forKey:@"pwd"];
    [json setInteger:self.resolution forKey:@"resolution"];
    [json setInteger:self.type forKey:@"type"];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setMayBlankString:self.nwkAddr forKey:@"nwkAddr"];
    [json setMayBlankString:self.user forKey:@"user"];
    return json;
}

- (NSString *)deviceStateAsString {
    if(self.state == 0) {
        return NSLocalizedString(@"device_offline", @"");
    } else if(self.state == 1) {
        return NSLocalizedString(@"device_online", @"");
    } else if(self.state == 2) {
        return NSLocalizedString(@"device_low_battery", @"");
    }
    return NSLocalizedString(@"unknow", @"");
}

- (NSString *)commandStringForStatus:(int)st {
    return [NSString stringWithFormat:@"%@-%@-%d", self.category, self.identifier, st];
}

- (NSString *)commandStringForCamera:(NSString *)direction {
    return [NSString stringWithFormat:@"%@-%@-%@", self.category, self.identifier, direction];
}

- (NSString *)commandStringForRemote:(int)st {
    return [NSString stringWithFormat:@"%@-%@-%d", self.category, self.nwkAddr, st];
}

#pragma mark -
#pragma mark Device type or state

- (BOOL)isOnline {
    return self.state != 0;
}

- (BOOL)isLowBattery {
    return self.state == 2;
}

- (BOOL)isAvailableDevice {
    return self.isAirPurifier || self.isCamera || self.isSensor || self.isSocket;
}

- (BOOL)isLight {
    return [@"light" isEqualToString:self.category];
}

- (BOOL)isInlight {
    return [@"lnlight" isEqualToString:self.category];
}

- (BOOL)isLightOrInlight {
    return [self isLight] || [self isInlight];
}

- (BOOL)isSocket {
    return [@"socket" isEqualToString:self.category];
}

- (BOOL)isCurtain {
    return [@"curtain" isEqualToString:self.category];
}

- (BOOL)isSccurtain {
    return [@"sccurtain" isEqualToString:self.category];
}

- (BOOL)isCurtainOrSccurtain {
    return [self isCurtain] || [self isSccurtain];
}

- (BOOL)isRemote {
    return [@"remote" isEqualToString:self.category];
}

- (BOOL)isTV {
    return [self isRemote] && self.irType == 1;
}

- (BOOL)isDVD {
    return [self isRemote] && self.irType == 2;
}

- (BOOL)isSTB {
    return [self isRemote] && self.irType == 3;
}

- (BOOL)isAircondition {
    return [self isRemote] && self.irType == 4;
}

- (BOOL)isBackgroundMusic {
    return [self isRemote] && self.irType == 6;
}

- (BOOL)isCamera {
    return [@"camera" isEqualToString:self.category];
}

- (BOOL)isWarsignal {
    return [@"warsignal" isEqualToString:self.category];
}

- (BOOL)isAirPurifier {
    return [@"airpurifier" isEqualToString:self.category];
}

- (BOOL)isSensor {
    return [@"sensor" isEqualToString:self.category];
}

- (BOOL)isSmokeDetector {
    if(!self.isSensor) return NO;
    return self.ep = 102;
}

- (BOOL)isBodyDetector {
    if(!self.isSensor) return NO;
    return self.ep = 100;
}

- (BOOL)isAirPurifierPower {
    if(!self.isAirPurifier) return NO;
    return self.ep == 1;
}

- (BOOL)isAirPurifierLevel {
    if(!self.isAirPurifier) return NO;
    return self.ep == 2;
}

- (BOOL)isAirPurifierModeControl {
    if(!self.isAirPurifier) return NO;
    return self.ep == 3;
}

- (BOOL)isAirPurifierSecurity {
    if(!self.isAirPurifier) return NO;
    return self.ep == 9;
}

@end
