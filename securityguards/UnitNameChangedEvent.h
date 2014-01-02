//
//  UnitNameChangedEvent.h
//  securityguards
//
//  Created by Zhao yang on 1/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "XXEvent.h"

@interface UnitNameChangedEvent : XXEvent

@property (nonatomic, strong) NSString *unitIdentifier;
@property (nonatomic, strong) NSString *unitName;

- (id)initWithIdentifier:(NSString *)identifier andName:(NSString *)name;

@end
