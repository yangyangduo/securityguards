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
        
        itemHigh.deviceState = 1;
        itemMedium.deviceState = 2;
        itemLow.deviceState = 3;
        
        [operations addObject:itemHigh];
        [operations addObject:itemMedium];
        [operations addObject:itemLow];
    } else if(device.isAirPurifierModeControl) {
        DeviceOperationItem *itemAutomatic = [[DeviceOperationItem alloc] init];
        DeviceOperationItem *itemManual = [[DeviceOperationItem alloc] init];
        
        itemManual.displayName = NSLocalizedString(@"device_manual", @"");
        itemAutomatic.displayName = NSLocalizedString(@"device_automatic", @"");
        
        itemManual.deviceState = 0;
        itemAutomatic.deviceState = 1;
        
        [operations addObject:itemManual];
        [operations addObject:itemAutomatic];
    } else if(device.isAirPurifierSecurity) {

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
        if(device.state == 0) {
            return NSLocalizedString(@"device_open", @"");
        } else if(device.state == 1) {
            return NSLocalizedString(@"device_close", @"");
        }
    } else if(device.isAirPurifierLevel) {
        if(device.state == 1) {
            return NSLocalizedString(@"high_level", @"");
        } else if(device.state == 2) {
            return NSLocalizedString(@"medium_level", @"");
        } else if(device.state == 3) {
            return NSLocalizedString(@"low_level", @"");
        }
    } else if(device.isAirPurifierSecurity) {
        
        
    } else if(device.isAirPurifierModeControl) {
        if(device.state == 0) {
            return NSLocalizedString(@"device_manual", @"");
        } else if(device.state == 1) {
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
