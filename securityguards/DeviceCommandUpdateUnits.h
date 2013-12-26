//
//  DeviceCommandUpdateUnits.h
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "Unit.h"

@interface DeviceCommandUpdateUnits : DeviceCommand

// Collections of units
@property (strong, nonatomic) NSMutableArray *units;

@end
