//
//  SensorStateChangedEvent.m
//  securityguards
//
//  Created by Zhao yang on 1/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SensorStateChangedEvent.h"

@implementation SensorStateChangedEvent

@synthesize unitIdentifier = _unitIdentifier_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventSensorStateChanged;
    }
    return self;
}

- (instancetype)initWithUnitIdentifier:(NSString *)unitIdentifier {
    self = [self init];
    if(self) {
        _unitIdentifier_ = unitIdentifier;
    }
    return self;
}

@end
