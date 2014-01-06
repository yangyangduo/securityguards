//
//  DeviceOperationItem.h
//  securityguards
//
//  Created by Zhao yang on 1/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceOperationItem : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *commandString;
@property (nonatomic, assign) unsigned int deviceState;

- (id)initWithDisplayName:(NSString *)displayName andCommandString:(NSString *)commandString;

@end
