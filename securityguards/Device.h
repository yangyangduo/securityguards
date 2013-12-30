//
//  Device.h
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@class Zone;

@interface Device : Entity

@property (strong, nonatomic) Zone *zone;

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *user;
@property (copy, nonatomic) NSString *ip;
@property (copy, nonatomic) NSString *nwkAddr;
@property (copy, nonatomic) NSString *pwd;
@property (assign, nonatomic) int ep;
@property (assign, nonatomic) int irType;
@property (assign, nonatomic) int port;
@property (assign, nonatomic) int resolution;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) int type;

@property (assign, nonatomic) BOOL isOnline;

@property (assign, nonatomic, readonly) BOOL isLight;                //灯
@property (assign, nonatomic, readonly) BOOL isInlight;              //零火灯
@property (assign, nonatomic, readonly) BOOL isLightOrInlight;       //灯或者零火灯
@property (assign, nonatomic, readonly) BOOL isSocket;               //插座
@property (assign, nonatomic, readonly) BOOL isCurtain;              //窗帘
@property (assign, nonatomic, readonly) BOOL isSccurtain;            //强电窗帘
@property (assign, nonatomic, readonly) BOOL isCurtainOrSccurtain;   //窗帘或者强电窗帘
@property (assign, nonatomic, readonly) BOOL isRemote;               //红外线
@property (assign, nonatomic, readonly) BOOL isTV;                   //红外线-电视机
@property (assign, nonatomic, readonly) BOOL isAircondition;         //红外线-空调
@property (assign, nonatomic, readonly) BOOL isSTB;                  //红外线-机顶盒
@property (assign, nonatomic, readonly) BOOL isCamera;               //摄像头
@property (assign, nonatomic, readonly) BOOL isWarsignal;            //安防,警报
@property (assign, nonatomic, readonly) BOOL isBackgroundMusic;      //背景音乐
@property (assign, nonatomic, readonly) BOOL isDVD;                  //DVD

@property (assign, nonatomic, readonly) BOOL isAvailableDevice;

// 获取执行命令的字符串
- (NSString *)commandStringForStatus:(int)st;
- (NSString *)commandStringForCamera:(NSString *)direction;
- (NSString *)commandStringForRemote:(int)st;

@end
