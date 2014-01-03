//
//  DeviceCommandGetNotificationsHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetNotificationsHandler.h"
#import "NotificationsFileManager.h"
#import "XXEventSubscriptionPublisher.h"
#import "NotificationsFileUpdatedEvent.h"
#import "SystemAudio.h"
#import "GlobalSettings.h"
#import "CommandFactory.h"

@implementation DeviceCommandGetNotificationsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    if([command isKindOfClass:[DeviceCommandUpdateNotifications class]]) {
        DeviceCommandUpdateNotifications *receivedNotificationsCommand = (DeviceCommandUpdateNotifications *)command;
        [[NotificationsFileManager fileManager] writeToDisk:receivedNotificationsCommand.notifications];
        
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[NotificationsFileUpdatedEvent alloc] init]];

        if([COMMAND_PUSH_NOTIFICATIONS isEqualToString:receivedNotificationsCommand.commandName]) {
            if([GlobalSettings defaultSettings].isVoice) {
                [SystemAudio playClassicSmsSound];
            }
            if([GlobalSettings defaultSettings].isShake) {
                [SystemAudio shake];
            }
        }
    }
}

@end
