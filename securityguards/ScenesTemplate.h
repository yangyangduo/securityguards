//
// Created by Zhao yang on 3/7/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"
#import "DeviceUtils.h"

static NSString * const kSceneReturnHome         = @"SceneReturnHome";
static NSString * const kSceneOut                = @"SceneOut";
static NSString * const kSceneGetUp              = @"SceneGetUp";
static NSString * const kSceneSleep              = @"SceneSleep";

static NSString * const kTemplateName            = @"TemplateName";
static NSString * const kAirPurifierPower        = @"AirPower";
static NSString * const kAirPurifierLevel        = @"AirLevel";
static NSString * const kAirPurifierModeControl  = @"AirModeControl";
static NSString * const kAirPurifierSecurity     = @"AirSecurity";


@interface SceneEntry : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;

@end

@interface ScenesTemplate : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *sceneEntries;

+ (NSDictionary *)defaultTemplates;
+ (void)executeDefaultTemplatesWithTemplateId:(NSString *)templateId forUnit:(Unit *)unit;

@end