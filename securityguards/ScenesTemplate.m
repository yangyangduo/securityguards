//
// Created by Zhao yang on 3/7/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "ScenesTemplate.h"

@implementation SceneEntry

@end

@implementation ScenesTemplate {

}

+ (void)executeDefaultTemplatesWithTemplateId:(NSString *)templateId forUnit:(Unit *)unit {
    if(unit == nil) return;
    NSDictionary *templates = [[self class] defaultTemplates];
    if(templates != nil) {
        NSDictionary *template = [templates dictionaryForKey:templateId];
        if(template == nil) return;
        NSMutableArray *items = [NSMutableArray array];
        NSArray *devices = unit.devices;
        for(int i=0; i<devices.count; i++) {
            Device *device = [devices objectAtIndex:i];
            NSString *parameterKey = nil;
            if(device.isAirPurifierPower) {
                parameterKey = [kAirPurifierPower copy];
            } else if(device.isAirPurifierLevel) {
                parameterKey = [kAirPurifierLevel copy];
            } else if(device.isAirPurifierModeControl) {
                parameterKey = [kAirPurifierModeControl copy];
            } else if(device.isAirPurifierSecurity) {
                parameterKey = [kAirPurifierSecurity copy];
            }
            if(![XXStringUtils isBlank:parameterKey]) {
                NSNumber *number = [template notNSNullObjectForKey:parameterKey];
                if(number != nil) {
                    DeviceOperationItem *item = [DeviceUtils operationItemFor:device withState:number.intValue];
                    if(item != nil) {
                        [items addObject:item];
                    }
                }
            }
        }
        [DeviceUtils executeOperationItems:items forUnit:unit.identifier];
    }
}

+ (NSDictionary *)defaultTemplates {
    static NSDictionary *defaultTemplates;

    if(defaultTemplates != nil) {
        return defaultTemplates;
    }

    NSDictionary *returnHomeTemplate = @{
            kTemplateName             : NSLocalizedString(@"scene_return_home", @""),
            kAirPurifierPower         : [NSNumber numberWithInt:kDeviceStateOpen],
            kAirPurifierSecurity      : [NSNumber numberWithInt:kDeviceSecurityClose],
            kAirPurifierModeControl   : [NSNumber numberWithInt:kDeviceAirPurifierControlModeAutomatic]
    };

    NSDictionary *outTemplate = @{
            kTemplateName             : NSLocalizedString(@"scene_out", @""),
            kAirPurifierPower         : [NSNumber numberWithInt:kDeviceStateClose],
            kAirPurifierSecurity      : [NSNumber numberWithInt:kDeviceSecurityAllOpen]
    };

    NSDictionary *getUpTemplate = @{
            kTemplateName             : NSLocalizedString(@"scene_get_up", @""),
            kAirPurifierPower         : [NSNumber numberWithInt:kDeviceStateClose],
            kAirPurifierSecurity      : [NSNumber numberWithInt:kDeviceSecurityClose]
    };

    NSDictionary *sleepTemplate = @{
            kTemplateName             : NSLocalizedString(@"scene_sleep", @""),
            kAirPurifierLevel         : [NSNumber numberWithInt:kDeviceAirPurifierLevelLow],
            kAirPurifierPower         : [NSNumber numberWithInt:kDeviceStateOpen],
            kAirPurifierSecurity      : [NSNumber numberWithInt:kDeviceSecurityAllOpen],
            kAirPurifierModeControl   : [NSNumber numberWithInt:kDeviceAirPurifierControlModeManual]
    };

    defaultTemplates = @{
            kSceneReturnHome : returnHomeTemplate,
            kSceneOut        : outTemplate,
            kSceneGetUp      : getUpTemplate,
            kSceneSleep      : sleepTemplate
    };

    return defaultTemplates;
}

@end