//
//  DeviceCommand.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "CommandFactory.h"
#import "ServiceBase.h"
#import "GlobalSettings.h"

@implementation DeviceCommand

@synthesize result;
@synthesize resultID;
@synthesize deviceCode;
@synthesize commandName;
@synthesize commandTime;
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;
@synthesize tcpAddress;
@synthesize hashCode;
@synthesize describe;

@synthesize restAddress;
@synthesize restPort;
@synthesize commandNetworkMode;

- (id)init {
    self = [super init];
    if(self) {
        self.commandNetworkMode = CommandNetworkModeNone;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)json {
    self = [self init];
    if(self) {
        if(json != nil) {
            self.deviceCode = [json stringForKey:@"deviceCode"];
            self.commandName = [json stringForKey:@"_className"];
            self.masterDeviceCode = [json stringForKey:@"masterDeviceCode"];
            self.tcpAddress = [json stringForKey:@"tcp"];
            self.result = [json stringForKey:@"id"];
            self.describe = [json stringForKey:@"describe"];
            self.hashCode = [json numberForKey:@"hashCode"];
            self.resultID = [json intForKey:@"resultId"];
            self.security = [json stringForKey:@"security"];
            self.restAddress = [json noNilStringForKey:@"rest"];
            self.commandTime = [json dateWithMillisecondsForKey:@"commandTime"];
        }
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    // commons
    [json setObject:APP_KEY forKey:@"appKey"];
    [json setNoNilObject:[GlobalSettings defaultSettings].secretKey forKey:@"security"];
    [json setNoBlankString:self.deviceCode forKey:@"deviceCode"];
    [json setNoBlankString:self.commandName forKey:@"_className"];
    [json setNoBlankString:self.masterDeviceCode forKey:@"masterDeviceCode"];
    [json setNoBlankString:self.describe forKey:@"describe"];
    [json setDateWithMilliseconds:self.commandTime forKey:@"commandTime"];
    
    if(([COMMAND_GET_UNITS isEqualToString:commandName] && ![XXStringUtils isBlank:self.masterDeviceCode])) {
        if(self.hashCode != nil) {
            [json setObject:self.hashCode forKey:@"hashCode"];
        } else {
            [json setObject:[NSNumber numberWithInteger:0] forKey:@"hashCode"];
        }
    }
    
    return json;
}

- (NSString *)appKey {
    return APP_KEY;
}

- (NSString *)deviceCode {
    if([XXStringUtils isBlank:deviceCode]) {
        return [GlobalSettings defaultSettings].deviceCode;
    }
    return deviceCode;
}

- (NSString *)security {
    if([XXStringUtils isBlank:security]) {
        return [GlobalSettings defaultSettings].secretKey;
    }
    return security;
}

- (BOOL)isEqual:(id)object {
    if(object == nil) return NO;
    if(self == object) return YES;
    if([object isKindOfClass:[self class]]) {
        DeviceCommand *cmd = (DeviceCommand *)object;
        if(![self.commandName isEqualToString:cmd.commandName]) {
            return NO;
        }
        if(![XXStringUtils string:self.masterDeviceCode isEqualString:cmd.masterDeviceCode]) {
            return NO;
        }
        
        if((self.hashCode == nil && cmd.hashCode != nil) || (self.hashCode != nil && cmd.hashCode == nil))
        {
            return NO;
        }
        if(self.hashCode != nil) {
            if(![self.hashCode isEqual:cmd.hashCode]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
