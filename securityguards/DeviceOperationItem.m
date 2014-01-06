//
//  DeviceOperationItem.m
//  securityguards
//
//  Created by Zhao yang on 1/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceOperationItem.h"

@implementation DeviceOperationItem

@synthesize displayName = _displayName_;
@synthesize commandString = _commandString_;
@synthesize deviceState;

- (id)initWithDisplayName:(NSString *)displayName andCommandString:(NSString *)commandString {
    self = [super init];
    if(self) {
        _displayName_ = displayName;
        _commandString_ = commandString;
    }
    return self;
}

@end
