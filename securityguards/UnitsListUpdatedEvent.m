//
//  UnitsListUpdatedEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsListUpdatedEvent.h"

@implementation UnitsListUpdatedEvent

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventUnitsListUpdated;
    }
    return self;
}

@end
