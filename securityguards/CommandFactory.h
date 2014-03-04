//
//  CommandFactory.h
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"
#import "DeviceCommandUpdateAccount.h"
#import "DeviceCommandUpdateUnits.h"
#import "DeviceCommandUpdateNotifications.h"
#import "DeviceCommandVoiceControl.h"
#import "DeviceCommandUpdateDevices.h"
#import "DeviceCommandUpdateUnitName.h"
#import "DeviceCommandUpdateDevice.h"
#import "DeviceCommandGetCameraServer.h"
#import "DeviceCommandReceivedCameraServer.h"
#import "DeviceCommandGetUnit.h"
#import "DeviceCommandAuthBinding.h"
#import "DeviceCommandUpdateDeviceToken.h"
#import "DeviceCommandCheckVersion.h"
#import "DeviceCommandReceivedSensors.h"
#import "DeviceCommandGetScore.h"


typedef NS_ENUM(NSUInteger, CommandType) {
    CommandTypeNone,
    CommandTypeUpdateAccount,
    CommandTypeGetAccount,
    CommandTypeGetUnits,
    CommandTypeGetNotifications,
    CommandTypeUpdateDeviceViaVoice,
    CommandTypeUpdateDevice,
    CommandTypeUpdateUnitName,
    CommandTypeGetCameraServer,
    CommandTypeBindingUnit,
    CommandTypeAuthBindingUnit,
    CommandTypeUpdateDeviceToken,
    CommandTypeCheckVersion,
    CommandTypeSendHeartBeat,
    CommandTypeGetSensors,
    CommandTypeGetScore,
};

#define COMMAND_UPDATE_ACCOUNT       @"AccountUpdateCommand"
#define COMMAND_GET_ACCOUNT          @"AccountProfileCommand"
#define COMMAND_GET_UNITS            @"FindZKListCommand"
#define COMMAND_GET_NOTIFICATIONS    @"AccountMQListCommand"
#define COMMAND_VOICE_CONTROL        @"VoiceControlCommand"
#define COMMAND_KEY_CONTROL          @"KeyControlCommand"
#define COMMAND_CHANGE_UNIT_NAME     @"DeviceChangeNameCommand"
#define COMMAND_GET_CAMERA_SERVER    @"RequestCameraCommand"
#define COMMAND_PUSH_NOTIFICATIONS   @"MessageQueueCommand"
#define COMMAND_PUSH_DEVICE_STATUS   @"DeviceFingerExcuteCommand"
#define COMMAND_BING_UNIT            @"DeviceBindingCommand"
#define COMMAND_AUTH_BINGDING        @"DeviceBindingAuthCommand"
#define COMMAND_UPDATE_DEVICE_TOKEN  @"IOSSecretCommand"
#define COMMAND_CHECK_VERSION        @"VersionUpgradeCommand"
#define COMMAND_SEND_HEART_BEAT      @"HeartBeatCommand"
#define COMMAND_GET_SENSORS          @"FindSensorDataCommand"
#define COMMAND_GET_SCORE            @"GetUnitScore"

@interface CommandFactory : NSObject

+ (DeviceCommand *)commandForType:(CommandType)type;
+ (DeviceCommand *)commandFromJson:(NSDictionary *)json;

@end
