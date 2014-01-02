//
//  DeviceCommandUpdateUnitNameHandler.m
//  securityguards
//
//  Created by Zhao yang on 1/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitNameHandler.h"
#import "DeviceCommandUpdateUnitName.h"
#import "UnitNameChangedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "UnitManager.h"

@implementation DeviceCommandUpdateUnitNameHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateUnitName class]]) {
        DeviceCommandUpdateUnitName *updateUnitNameCommand = (DeviceCommandUpdateUnitName *)command;
        UnitNameChangedEvent *event;
        
        if(updateUnitNameCommand.resultID == 1) {
            Unit *unit = [[UnitManager defaultManager] findUnitByIdentifier:updateUnitNameCommand.masterDeviceCode];
            if(unit != nil) {
                unit.name = updateUnitNameCommand.name;
            }
            event = [[UnitNameChangedEvent alloc] initWithIdentifier:updateUnitNameCommand.masterDeviceCode andName:updateUnitNameCommand.name];
        } else {
            event = [[UnitNameChangedEvent alloc] init];
        }
        
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
    }
}

@end
