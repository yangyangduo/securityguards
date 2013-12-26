//
//  CurrentUnitChangedEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CurrentUnitChangedEvent.h"

@implementation CurrentUnitChangedEvent

@synthesize unitIdentifier = _unitIdentifier_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventCurrentUnitChanged;
    }
    return self;
}

- (id)initWithCurrentIdentifier:(NSString *)identifier {
    self = [self init];
    if(self) {
        _unitIdentifier_ = identifier;
    }
    return self;
}

@end
