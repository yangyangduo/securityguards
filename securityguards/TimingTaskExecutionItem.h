//
//  TimingTaskExecutionItem.h
//  securityguards
//
//  Created by Zhao yang on 1/26/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"
#import "Device.h"

#define DEFAULT_STATUS -1000

@interface TimingTaskExecutionItem : Entity

@property (nonatomic, strong) NSString *deviceIdentifier;
@property (nonatomic, strong) NSString *executionCommandString;
@property (nonatomic) int status;
@property (nonatomic, strong) Device *device;
@property (nonatomic, readonly, getter = isAvailableItem) BOOL isAvailable;

- (void)updateWithJson:(NSDictionary *)json;

@end
