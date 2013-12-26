//
//  DeviceCommandUpdateUnits.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnits.h"

@implementation DeviceCommandUpdateUnits

@synthesize units;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        if(json != nil) {
            NSArray *_units_ = [json arrayForKey:@"zkList"];
            if(_units_ != nil && [_units_ isKindOfClass:[NSArray class]]) {
                for(int i=0; i<_units_.count; i++) {
                    NSDictionary *_unit_ = [_units_ objectAtIndex:i];
                    if(_unit_ != nil) {
                        Unit *unit = [[Unit alloc] initWithJson:_unit_];
                        if(unit != nil) {
                            [self.units addObject:unit];
                        }
                    }
                }
            }
        }
    }
    return self;
}

- (NSMutableArray *)units {
    if(units == nil) {
        units = [NSMutableArray array];
    }
    return units;
}

@end
