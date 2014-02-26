//
//  LeftNavItem.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LeftNavItem.h"

@implementation LeftNavItem

@synthesize identifier = _identifier_;
@synthesize displayName = _displayName_;
@synthesize imageName = _imageName_;

- (id)initWithIdentifier:(NSString *)identifier andDisplayName:(NSString *)displayName andImageName:(NSString *)imageName {
    self = [super init];
    if(self) {
        _identifier_ = identifier;
        _displayName_ = displayName;
        _imageName_ = imageName;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if(object == nil) return NO;
    if(![object isMemberOfClass:[LeftNavItem class]]) return NO;
    LeftNavItem *it = object;
    if(it.identifier == nil) return NO;
    return [it.identifier isEqualToString:self.identifier];
}

@end
