//
//  RestfulCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RestfulCommandService.h"
#import "XXEventSubscriptionPublisher.h"
#import "DeviceCommandEvent.h"
#import "UnitManager.h"
#import "CoreService.h"

@implementation RestfulCommandService

- (id)init {
    self = [super init];
    if(self) {
        [super setupWithUrl:[XXStringUtils emptyString]];
        self.client.timeoutInterval = 6;
    }
    return self;
}

- (void)executeCommand:(DeviceCommand *)command {
    Unit *unit = [[UnitManager defaultManager] findUnitByIdentifier:command.masterDeviceCode];

    if(unit != nil) {
        command.restAddress = unit.localIP;
        command.restPort = unit.localPort;
    }
    
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        DeviceCommandGetUnit *getUnitCommand = (DeviceCommandGetUnit *)command;
        if([XXStringUtils isBlank:getUnitCommand.unitServerUrl]) {
            [self getUnitByIdentifier:getUnitCommand.masterDeviceCode address:getUnitCommand.restAddress port:getUnitCommand.restPort hashCode:getUnitCommand.hashCode];
        } else {
            [self getUnitByUrl:getUnitCommand.unitServerUrl];
        }
    } else if([COMMAND_KEY_CONTROL isEqualToString:command.commandName]) {
        DeviceCommandUpdateDevice *updateDevice = (DeviceCommandUpdateDevice *)command;
        NSData *data = [JsonUtils createJsonDataFromDictionary:[updateDevice toDictionary]];
        [self updateDeviceWithAddress:updateDevice.restAddress port:updateDevice.restPort data:data];
    } else if([COMMAND_GET_SENSORS isEqualToString:command.commandName]) {
        if([XXStringUtils isBlank:command.masterDeviceCode]) return;
        NSString *url = nil;
        if(CommandNetworkModeInternal == command.commandNetworkMode) {
            url = [NSString stringWithFormat:@"http://%@:%d/sensor/%@%@",
                   command.restAddress, command.restPort, command.masterDeviceCode, APP_KEY];
        } else if(CommandNetworkModeExternalViaRestful == command.commandNetworkMode) {
            url = [NSString stringWithFormat:@"%@/sensor/%@%@?deviceCode=%@&appKey=%@&security=%@",
                   [GlobalSettings defaultSettings].restAddress, command.masterDeviceCode, APP_KEY,
                   [GlobalSettings defaultSettings].deviceCode,
                   APP_KEY,
                   [GlobalSettings defaultSettings].secretKey];
        }
        if(url) {
            [self getSensorsStateWithUnitIdentifier:command.masterDeviceCode url:url callback:command];
        }
    } else if([COMMAND_GET_CAMERA_SERVER isEqualToString:command.commandName]) {
        if([command isKindOfClass:[DeviceCommandGetCameraServer class]]) {
            DeviceCommandGetCameraServer *getCameraServerCmd = (DeviceCommandGetCameraServer *)command;
            DeviceCommandReceivedCameraServer *cmd = [[DeviceCommandReceivedCameraServer alloc] init];
            cmd.commandName = COMMAND_GET_CAMERA_SERVER;
            cmd.cameraId = getCameraServerCmd.cameraId;
            cmd.commandNetworkMode = CommandNetworkModeInternal;
            [self publishCommand:cmd];
        }
    } else if([COMMAND_GET_SCORE isEqualToString:command.commandName]) {
        NSString *url = [NSString stringWithFormat:@"%@/score/%@%@?deviceCode=%@&appKey=%@&security=%@"
                , [GlobalSettings defaultSettings].restAddress, command.masterDeviceCode, APP_KEY
                , [GlobalSettings defaultSettings].deviceCode, APP_KEY, [GlobalSettings defaultSettings].secretKey];
        [self getScoreWithUnitIdentifier:command.masterDeviceCode withUrl:url];
    }
}

- (NSString *)executorName {
    return @"RESTFUL SERVICE";
}

#pragma mark -
#pragma mark Publish Command

- (void)publishCommand:(DeviceCommand *)command {
    DeviceCommandEvent *event = [[DeviceCommandEvent alloc] initWithDeviceCommand:command];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
}

#pragma mark -
#pragma mark Get Score

- (void)getScoreWithUnitIdentifier:(NSString *)unitIdentifier withUrl:(NSString *)url {
    [self.client getForUrl:url acceptType:@"text/html" success:@selector(getScoreSuccess:) error:@selector(getScoreFailed:) for:self callback:unitIdentifier];
}

- (void)getScoreSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            int result = [json intForKey:@"i"];
            if(result == 1) {
                NSDictionary *_json_result_ = [json dictionaryForKey:@"m"];
                DeviceCommandGetScore *getScoreCommand = [[DeviceCommandGetScore alloc] initWithDictionary:_json_result_];
                getScoreCommand.commandNetworkMode = CommandNetworkModeExternalViaRestful;
                getScoreCommand.masterDeviceCode = resp.callbackObject;
                [self publishCommand:getScoreCommand];
                return;
            }
        }
    }
    [self getScoreFailed:resp];
}

- (void)getScoreFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[RESTFUL COMMAND SERVICE] Get score failed, status code is %d", resp.statusCode);
#endif
}

#pragma mark -
#pragma mark Sensor's data

- (void)getSensorsStateWithUnitIdentifier:(NSString *)unitIdentifier url:(NSString *)url callback:(id)cb {
    [self.client getForUrl:url acceptType:@"text/*" success:@selector(getSensorsStateSuccess:) error:@selector(getSensorsStateFailed:) for:self callback:cb];
}

- (void)getSensorsStateSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            if([json intForKey:@"i"] == 1) {
                DeviceCommandReceivedSensors *command = [[DeviceCommandReceivedSensors alloc] initWithDictionary:json];
                if([@"i" isEqualToString:resp.callbackObject]) {
                    command.commandNetworkMode = CommandNetworkModeInternal;
                } else if([@"e" isEqualToString:resp.callbackObject]) {
                    command.commandNetworkMode = CommandNetworkModeExternalViaRestful;
                }
                DeviceCommand *cmd = resp.callbackObject;
                command.masterDeviceCode = cmd.masterDeviceCode;
                command.commandNetworkMode = cmd.commandNetworkMode;
                command.commandName = cmd.commandName;
                [self publishCommand:command];
                return;
            }
        }
    }
    [self getSensorsStateFailed:resp];
}

- (void)getSensorsStateFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[RESTFUL COMMAND SERVICE] Get sensors failed, status code is %d", resp.statusCode);
#endif
}

#pragma mark -
#pragma mark Update devices from rest server

- (void)updateDeviceWithAddress:(NSString *)address port:(int)port data:(NSData *)data {
    NSString *url = [NSString stringWithFormat:@"http://%@:%d/executor", address, port];
    [self.client postForUrl:url acceptType:@"application/json" contentType:@"application/json" body:data success:@selector(updateDeviceSuccess:) error:@selector(updateDeviceFailed:) for:self callback:nil];
}

- (void)updateDeviceSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        DeviceCommand *command = [CommandFactory commandFromJson:[JsonUtils createDictionaryFromJson:resp.body]];
        command.commandNetworkMode = CommandNetworkModeInternal;
        [self publishCommand:command];
        return;
    }
    [self updateDeviceFailed:resp];
}

- (void)updateDeviceFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[RESTFUL COMMAND SERVICE] Update device failed, status code is %d", resp.statusCode);
#endif
}

#pragma mark -
#pragma mark Get units from rest server

- (void)getUnitByIdentifier:(NSString *)unitIdentifier address:(NSString *)addr port:(int)port hashCode:(NSNumber *)hashCode {
        NSString *url = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg?hashCode=%d", addr, port, hashCode.intValue];
        [self getUnitByUrl:url];
}

- (void)getUnitByUrl:(NSString *)url {
    [self.client getForUrl:url acceptType:@"application/json" success:@selector(getUnitSuccess:) error:@selector(getUnitFailed:) for:self callback:nil];
}

- (void)getUnitSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            Unit *unit = [[Unit alloc] initWithJson:json];
            if(unit != nil) {
                DeviceCommandUpdateUnits *updateUnit = [[DeviceCommandUpdateUnits alloc] init];
                updateUnit.commandName = COMMAND_GET_UNITS;
                updateUnit.masterDeviceCode = unit.identifier;
                updateUnit.commandNetworkMode = CommandNetworkModeInternal;
                [updateUnit.units addObject:unit];
                //Current network mode must be internal, because this callback is from rest service .
                [[CoreService defaultService] addNetMode:NetModeInternal];
                [self publishCommand:updateUnit];
            }
        }
        return;
    } else if(resp.statusCode == 204) {
        // ignore this ... do not need to refresh local unit
        return;
    }
    [self getUnitFailed:resp];
}

- (void)getUnitFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[RESTFUL COMMAND SERVICE] Get unit failed, staus code is %d", resp.statusCode);
#endif
}

@end
