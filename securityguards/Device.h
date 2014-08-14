//
//  Device.h
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

extern int const kDeviceStateIgnore;

extern int const kDeviceStateClose;
extern int const kDeviceStateOpen;

extern int const kDeviceAirPurifierLevelHigh;
extern int const kDeviceAirPurifierLevelMedium;
extern int const kDeviceAirPurifierLevelLow;

extern int const kDeviceSecurityClose;
extern int const kDeviceSecurityOpen;

extern int const kDeviceAirPurifierControlModeAutomatic;
extern int const kDeviceAirPurifierControlModeManual;
extern int const kDeviceAirPurifierControlModeSleepOrWakeUp;

@class Zone;

@interface Device : Entity

@property (nonatomic, strong) Zone *zone;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *nwkAddr;
@property (nonatomic, strong) NSString *pwd;

@property (nonatomic) int ep;
@property (nonatomic) int irType;
@property (nonatomic) int port;
@property (nonatomic) int resolution;
@property (nonatomic) int state;
@property (nonatomic) int status;
@property (nonatomic) int type;

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) BOOL isLight;                    //灯
@property (nonatomic, readonly) BOOL isInlight;                  //零火灯
@property (nonatomic, readonly) BOOL isLightOrInlight;           //灯或者零火灯
@property (nonatomic, readonly) BOOL isSocket;                   //插座
@property (nonatomic, readonly) BOOL isCurtain;                  //窗帘
@property (nonatomic, readonly) BOOL isSccurtain;                //强电窗帘
@property (nonatomic, readonly) BOOL isCurtainOrSccurtain;       //窗帘或者强电窗帘
@property (nonatomic, readonly) BOOL isRemote;                   //红外线
@property (nonatomic, readonly) BOOL isTV;                       //红外线-电视机
@property (nonatomic, readonly) BOOL isAircondition;             //红外线-空调
@property (nonatomic, readonly) BOOL isSTB;                      //红外线-机顶盒
@property (nonatomic, readonly) BOOL isCamera;                   //摄像头
@property (nonatomic, readonly) BOOL isWarsignal;                //安防,警报
@property (nonatomic, readonly) BOOL isBackgroundMusic;          //背景音乐
@property (nonatomic, readonly) BOOL isDVD;                      //DVD

@property (nonatomic, readonly) BOOL isAirPurifier;              //空气净化器
@property (nonatomic, readonly) BOOL isAirPurifierPower;         //空气净化器电源
@property (nonatomic, readonly) BOOL isAirPurifierLevel;         //空气净化器档位
@property (nonatomic, readonly) BOOL isAirPurifierModeControl;   //空气净化器(自动，手动模式切换)
@property (nonatomic, readonly) BOOL isAirPurifierSecurity;      //空气净化器安防

@property (nonatomic, readonly) BOOL isSensor;

@property (nonatomic, readonly) BOOL isAvailableDevice;

// 获取执行命令的字符串
- (NSString *)commandStringForStatus:(int)st;
- (NSString *)commandStringForCamera:(NSString *)direction;
- (NSString *)commandStringForRemote:(int)st;

- (NSString *)deviceStateAsString;

@end
