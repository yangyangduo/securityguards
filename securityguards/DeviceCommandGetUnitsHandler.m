//
//  DeviceCommandGetUnitsHandler.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetUnitsHandler.h"
#import "CommandFactory.h"
#import "Unit.h"
#import "UnitsListUpdatedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "UnitManager.h"

@implementation DeviceCommandGetUnitsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateUnits class]]) {
        
        DeviceCommandUpdateUnits *updateUnitsCommand = (DeviceCommandUpdateUnits *)command;
        
        // update units
        if([XXStringUtils isBlank:updateUnitsCommand.masterDeviceCode]) {
            [[UnitManager defaultManager] replaceUnits:updateUnitsCommand.units];
        // update unit
        } else {
            if(updateUnitsCommand.resultID == -1) {
                // this unit is has not binding before, need to remove it .
                [[UnitManager defaultManager] removeUnitByIdentifier:updateUnitsCommand.masterDeviceCode];
            } else {
                // the array of units only contains one unit
                if(updateUnitsCommand.units.count > 0) {
                    Unit *unit = [updateUnitsCommand.units objectAtIndex:0];
                    [[UnitManager defaultManager] updateUnit:unit];
                }
            }
        }
        
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[UnitsListUpdatedEvent alloc] init]];
    }
}

@end
