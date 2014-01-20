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

+ (NSMutableArray *)operationsListFor:(Device *)device {
    NSMutableArray *operations = [NSMutableArray array];
    if(device == nil) return operations;
    
    // set display name and state
    
    if(device.isAirPurifierPower) {
        DeviceOperationItem *itemOn = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemOff = [[DeviceOperationItem alloc] init];
        
        itemOn.displayName = NSLocalizedString(@"device_open", @"");
        itemOff.displayName = NSLocalizedString(@"device_close", @"");
        
        itemOn.deviceState = 0;
        itemOff.deviceState = 1;
        
        [operations addObject:itemOn];
        [operations addObject:itemOff];
    } else if(device.isAirPurifierLevel) {
        DeviceOperationItem *itemHigh = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemMedium = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemLow = [[DeviceOperationItem alloc] init];

        itemHigh.displayName = NSLocalizedString(@"high_level", @"");
        itemMedium.displayName = NSLocalizedString(@"medium_level", @"");
        itemLow.displayName = NSLocalizedString(@"low_level", @"");
        
        itemHigh.deviceState = 2;
        itemMedium.deviceState = 1;
        itemLow.deviceState = 0;
        
        [operations addObject:itemHigh];
        [operations addObject:itemMedium];
        [operations addObject:itemLow];
    } else if(device.isAirPurifierModeControl) {
        DeviceOperationItem *itemAutomatic = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemManual = [[DeviceOperationItem alloc] init];
        
        itemManual.displayName = NSLocalizedString(@"device_manual", @"");
        itemAutomatic.displayName = NSLocalizedString(@"device_automatic", @"");
        
        itemAutomatic.deviceState = 0;
        itemManual.deviceState = 1;
        
        [operations addObject:itemManual];
        [operations addObject:itemAutomatic];
    } else if(device.isAirPurifierSecurity) {
        DeviceOperationItem *itemAllOpen = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemClosed = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemFiresproof = [[DeviceOperationItem alloc] init];
        
        itemAllOpen.displayName = NSLocalizedString(@"security_all_open", @"");
        itemClosed.displayName = NSLocalizedString(@"security_close", @"");
        itemFiresproof.displayName = NSLocalizedString(@"security_fireproof", @"");
        
        itemAllOpen.deviceState = 0;
        itemClosed.deviceState = 1;
        itemFiresproof.deviceState = 2;
        
        [operations addObject:itemAllOpen];
        [operations addObject:itemClosed];
        [operations addObject:itemFiresproof];
    }
    
    // set command strings
    
    for(int i=0; i<operations.count; i++) {
        DeviceOperationItem *item = [operations objectAtIndex:i];
        item.commandString = [device commandStringForStatus:item.deviceState];
    }
    
    return operations;
}

+ (NSString *)stateAsStringFor:(Device *)device {
    if(device == nil) return [XXStringUtils emptyString];
    if(device.isAirPurifierPower) {
        if(device.status == 0) {
            return NSLocalizedString(@"device_open", @"");
        } else if(device.status == 1) {
            return NSLocalizedString(@"device_close", @"");
        }
    } else if(device.isAirPurifierLevel) {
        if(device.status == 2) {
            return NSLocalizedString(@"high_level", @"");
        } else if(device.status == 1) {
            return NSLocalizedString(@"medium_level", @"");
        } else if(device.status == 0) {
            return NSLocalizedString(@"low_level", @"");
        }
    } else if(device.isAirPurifierSecurity) {
        if(device.status == 0) {
            return NSLocalizedString(@"security_all_open", @"");
        } else if(device.status == 1) {
            return NSLocalizedString(@"security_close", @"");
        } else if(device.status == 2) {
            return NSLocalizedString(@"security_fireproof", @"");
        }
    } else if(device.isAirPurifierModeControl) {
        if(device.status == 1) {
            return NSLocalizedString(@"device_manual", @"");
        } else if(device.status == 0) {
            return NSLocalizedString(@"device_automatic", @"");
        }
    }
    return NSLocalizedString(@"unknow", @"");
}

+ (void)executeOperationItem:(DeviceOperationItem *)operationItem {
    if(operationItem == nil || [XXStringUtils isBlank:operationItem.commandString]) return;
    DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    updateDeviceCommand.masterDeviceCode = @"";
    [updateDeviceCommand addCommandString:@""];
    [[CoreService defaultService] executeDeviceCommand:updateDeviceCommand];
}

@end
