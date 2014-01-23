//
//  SensorStateChangedEvent.h
//  securityguards
//
//  Created by Zhao yang on 1/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "EventNameContants.h"

@interface SensorStateChangedEvent : XXEvent

@property (nonatomic, strong) NSString *unitIdentifier;

- (instancetype)initWithUnitIdentifier:(NSString *)unitIdentifier;

@end
