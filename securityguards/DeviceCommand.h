//
//  DeviceCommand.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"
#import "JsonUtils.h"

typedef NS_ENUM(NSUInteger, CommandNetworkMode) {
    CommandNetworkModeNone,
    CommandNetworkModeInternal,
    CommandNetworkModeExternalViaTcpSocket,
    CommandNetworkModeExternalViaRestful,
};

@interface DeviceCommand : NSObject

@property (strong, nonatomic) NSString *result;
@property (assign, nonatomic) int resultID;
@property (strong, nonatomic) NSString *deviceCode;
@property (strong, nonatomic) NSString *commandName;
@property (strong, nonatomic) NSString *masterDeviceCode;
@property (strong, nonatomic, readonly) NSString *appKey;
@property (strong, nonatomic) NSString *security;
@property (strong, nonatomic) NSString *tcpAddress;
@property (strong, nonatomic) NSDate *commandTime;
@property (strong, nonatomic) NSNumber *hashCode;
@property (strong, nonatomic) NSString *describe;

@property (strong, nonatomic) NSString *restAddress;
@property (assign, nonatomic) int restPort;
@property (assign, nonatomic) CommandNetworkMode commandNetworkMode;

- (id)initWithDictionary:(NSDictionary *)json;
- (NSMutableDictionary *)toDictionary;

@end
