//
//  NetworkModeChangedEvent.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NetworkModeChangedEvent.h"

@implementation NetworkModeChangedEvent

@synthesize networkMode = _networkMode_;

- (id)init {
    self = [super init];
    if(self) {
        self.name = EventNetworkModeChanged;
    }
    return self;
}

- (id)initWithNetworkMode:(NetworkMode)networkMode {
    self = [self init];
    if(self) {
        _networkMode_ = networkMode;
    }
    return self;
}

@end
