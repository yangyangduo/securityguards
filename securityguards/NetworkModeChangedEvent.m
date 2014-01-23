//
//  NetworkModeChangedEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NetworkModeChangedEvent.h"

@implementation NetworkModeChangedEvent

@synthesize netMode = _netMode_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventNetworkModeChanged;
    }
    return self;
}

- (id)initWithNetMode:(NetMode)netMode {
    self = [self init];
    if(self) {
        _netMode_ = netMode;
    }
    return self;
}

@end
