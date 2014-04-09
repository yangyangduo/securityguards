//
//  DeviceCommandGetSensorsHandler.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceCommandGetSensorsHandler.h"
#import "UnitManager.h"
#import "XXEventSubscriptionPublisher.h"
#import "SensorStateChangedEvent.h"

@implementation DeviceCommandGetSensorsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    if(command == nil || ![command isKindOfClass:[DeviceCommandReceivedSensors class]]) {
        return;
    }
    
    DeviceCommandReceivedSensors *cmd = (DeviceCommandReceivedSensors *)command;
    
    Unit *unit = [[UnitManager defaultManager] findUnitByIdentifier:cmd.masterDeviceCode];
    if(unit != nil) {
        unit.sensors = cmd.sensors;
        [[UnitManager defaultManager] syncUnitsToDisk];
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[SensorStateChangedEvent alloc] initWithUnitIdentifier:cmd.masterDeviceCode]];
    }
}

@end
