//
// Created by Zhao yang on 3/7/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"
#import "DeviceUtils.h"

static const NSString *kSceneReturnHome         = @"SceneReturnHome";
static const NSString *kSceneOut                = @"SceneOut";
static const NSString *kSceneGetUp              = @"SceneGetUp";
static const NSString *kSceneSleep              = @"SceneSleep";

static const NSString *kTemplateName            = @"TemplateName";
static const NSString *kAirPurifierPower        = @"AirPower";
static const NSString *kAirPurifierLevel        = @"AirLevel";
static const NSString *kAirPurifierModeControl  = @"AirModeControl";
static const NSString *kAirPurifierSecurity     = @"AirSecurity";


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