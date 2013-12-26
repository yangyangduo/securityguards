//
//  NetworkModeChangedEvent.h
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "CoreService.h"
#import "EventNameContants.h"

@interface NetworkModeChangedEvent : XXEvent

@property (assign, nonatomic, readonly) NetworkMode networkMode;

- (id)initWithNetworkMode:(NetworkMode)networkMode;

@end
