//
//  DeviceUtils.m
//  securityguards
//
//  Created by Zhao yang on 1/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceUtils.h"
#import "CommandFactory.h"
#import "CoreService.h"

@implementation DeviceUtils

+ (DeviceOperationItem *)operationItemFor:(Device *)device withState:(int)state {
    NSMutableArray *operations = [[self class] operationsListFor:device];
    if(operations.count == 0) return nil;
    for(DeviceOperationItem *item in operations) {
        if(state == item.deviceState) {
            return item;
        }
    }
    return nil;
}

/*
 
 */
+ (NSMutableArray *)operationsListFor:(Device *)device {
    return [[self class] operationsListFor:device deviceState:kDeviceStateIgnore];
}


+ (NSMutableArray *)operationsListFor:(Device *)device deviceState:(unsigned int)deviceState {
    NSMutableArray *operations = [NSMutableArray array];
    if(device == nil) return operations;
    
    // set display name and state
    
    if(device.isAirPurifierPower) {
        DeviceOperationItem *itemOn = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemOff = [[DeviceOperationItem alloc] init];
        
        itemOn.displayName = NSLocalizedString(@"device_open", @"");
        itemOff.displayName = NSLocalizedString(@"device_close", @"");
        
        itemOn.deviceState = kDeviceStateOpen;
        itemOff.deviceState = kDeviceStateClose;
        
        [operations addObject:itemOn];
        [operations addObject:itemOff];
    } else if(device.isAirPurifierLevel) {
        DeviceOperationItem *itemHigh = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemMedium = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemLow = [[DeviceOperationItem alloc] init];

        itemHigh.displayName = NSLocalizedString(@"high_level", @"");
        itemMedium.displayName = NSLocalizedString(@"medium_level", @"");
        itemLow.displayName = NSLocalizedString(@"low_level", @"");
        
        itemHigh.deviceState = kDeviceAirPurifierLevelHigh;
        itemMedium.deviceState = kDeviceAirPurifierLevelMedium;
        itemLow.deviceState = kDeviceAirPurifierLevelLow;
        
        [operations addObject:itemHigh];
        [operations addObject:itemMedium];
        [operations addObject:itemLow];
    } else if(device.isAirPurifierModeControl) {
        DeviceOperationItem *itemAutomatic = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemManual = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemSleepOrWakeup = [[DeviceOperationItem alloc] init];
        
        itemManual.displayName = NSLocalizedString(@"device_manual", @"");
        itemAutomatic.displayName = NSLocalizedString(@"device_automatic", @"");
        
        itemAutomatic.deviceState = kDeviceAirPurifierControlModeAutomatic;
        itemManual.deviceState = kDeviceAirPurifierControlModeManual;
        itemSleepOrWakeup.deviceState = kDeviceAirPurifierControlModeSleepOrWakeUp;
        
        if(kDeviceStateIgnore != deviceState) {
            if(kDeviceAirPurifierControlModeSleepOrWakeUp == deviceState) {
                itemSleepOrWakeup.displayName = NSLocalizedString(@"device_wakeup", @"");
                [operations addObject:itemSleepOrWakeup];
            }
        }
        
        if(operations.count == 0) {
            itemSleepOrWakeup.displayName = NSLocalizedString(@"device_sleep", @"");
            [operations addObject:itemManual];
            [operations addObject:itemAutomatic];
            [operations addObject:itemSleepOrWakeup];
        }
        
    } else if(device.isAirPurifierSecurity) {
        DeviceOperationItem *itemAllOpen = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemClosed = [[DeviceOperationItem alloc] init];
        
        itemAllOpen.displayName = NSLocalizedString(@"security_all_open", @"");
        itemClosed.displayName = NSLocalizedString(@"security_close", @"");
        
        itemAllOpen.deviceState = kDeviceSecurityOpen;
        itemClosed.deviceState = kDeviceSecurityClose;
        
        [operations addObject:itemAllOpen];
        [operations addObject:itemClosed];
    } else if(device.isSocket) {
        DeviceOperationItem *itemOn = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemOff = [[DeviceOperationItem alloc] init];
        
        itemOn.displayName = NSLocalizedString(@"device_open", @"");
        itemOff.displayName = NSLocalizedString(@"device_close", @"");
        
        itemOn.deviceState = kDeviceStateOpen;
        itemOff.deviceState = kDeviceStateClose;
        
        [operations addObject:itemOn];
        [operations addObject:itemOff];
    }
    
    // set command strings and unit identifier for each item
    
    for(int i=0; i<operations.count; i++) {
        DeviceOperationItem *item = [operations objectAtIndex:i];
        item.unitIdentifier = device.zone.unit.identifier;
        item.commandString = [device commandStringForStatus:item.deviceState];
    }
    
    return operations;
}

+ (NSString *)statusAsStringFor:(Device *)device {
    return [[self class] statusAsStringFor:device status:device.status];
}

+ (NSString *)statusAsStringFor:(Device *)device status:(int)status {
    if(device == nil) return [XXStringUtils emptyString];
    if(device.isAirPurifierPower) {
        if(status == kDeviceStateOpen) {
            return NSLocalizedString(@"device_open", @"");
        } else if(status == kDeviceStateClose) {
            return NSLocalizedString(@"device_close", @"");
        }
    } else if(device.isAirPurifierLevel) {
        if(status == kDeviceAirPurifierLevelHigh) {
            return NSLocalizedString(@"high_level", @"");
        } else if(status == kDeviceAirPurifierLevelMedium) {
            return NSLocalizedString(@"medium_level", @"");
        } else if(status == kDeviceAirPurifierLevelLow) {
            return NSLocalizedString(@"low_level", @"");
        }
    } else if(device.isAirPurifierSecurity) {
        if(status == kDeviceSecurityOpen) {
            return NSLocalizedString(@"security_all_open", @"");
        } else if(status == kDeviceSecurityClose) {
            return NSLocalizedString(@"security_close", @"");
        }
    } else if(device.isAirPurifierModeControl) {
        if(status == kDeviceAirPurifierControlModeManual) {
            return NSLocalizedString(@"device_manual", @"");
        } else if(status == kDeviceAirPurifierControlModeAutomatic) {
            return NSLocalizedString(@"device_automatic", @"");
        } else if(status == kDeviceAirPurifierControlModeSleepOrWakeUp) {
            return NSLocalizedString(@"device_sleep", @"");
        }
    } else if(device.isSocket) {
        if(status == kDeviceStateOpen) {
            return NSLocalizedString(@"device_open", @"");
        } else if(status == kDeviceStateClose) {
            return NSLocalizedString(@"device_close", @"");
        }
    }
    return NSLocalizedString(@"unknow", @"");
}

+ (NSString *)stateAsString:(int)state {
    if(state == 0) {
        return NSLocalizedString(@"device_offline", @"");
    } else {
        return NSLocalizedString(@"device_online", @"");
    }
}

+ (void)executeOperationItem:(DeviceOperationItem *)operationItem {
    if(operationItem == nil ||
       [XXStringUtils isBlank:operationItem.unitIdentifier] ||
       [XXStringUtils isBlank:operationItem.commandString]) return;
    
    DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    updateDeviceCommand.masterDeviceCode = operationItem.unitIdentifier;
    [updateDeviceCommand addCommandString:operationItem.commandString];
    [[CoreService defaultService] executeDeviceCommand:updateDeviceCommand];
}

+ (void)executeOperationItems:(NSArray *)operationItems forUnit:(NSString *)unitIdentifier {
    if(operationItems == nil || operationItems.count == 0) return;

    BOOL needFindIdentifierAgain = NO;
    NSString *_id_ = unitIdentifier;
    if([XXStringUtils isBlank:_id_]) {
        needFindIdentifierAgain = YES;
    }

    DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    for(int i=0; i<operationItems.count; i++) {
        DeviceOperationItem *item = [operationItems objectAtIndex:i];
        [updateDeviceCommand addCommandString:item.commandString];
        if(needFindIdentifierAgain) {
            _id_ = item.unitIdentifier;
            needFindIdentifierAgain = [XXStringUtils isBlank:_id_];
        }
    }
    updateDeviceCommand.masterDeviceCode = _id_;
#ifdef DEBUG
    NSLog(@"Execute scenes for [%@] with command strings -->  %@", updateDeviceCommand.masterDeviceCode, updateDeviceCommand.executions);
#endif
    [[CoreService defaultService] executeDeviceCommand:updateDeviceCommand];
}

@end
