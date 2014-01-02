//
//  UnitNameChangedEvent.m
//  securityguards
//
//  Created by Zhao yang on 1/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitNameChangedEvent.h"
#import "EventNameContants.h"

@implementation UnitNameChangedEvent

@synthesize unitIdentifier = _unitIdentifier_;
@synthesize unitName = _unitName_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventUnitNameChanged;
    }
    return self;
}
- (id)initWithIdentifier:(NSString *)identifier andName:(NSString *)name {
    self = [self init];
    if(self) {
        _unitIdentifier_ = identifier;
        _unitName_ = name;
    }
    return self;
}

@end
