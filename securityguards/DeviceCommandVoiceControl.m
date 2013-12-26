//
//  DeviceCommandVoiceControl.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandVoiceControl.h"

@implementation DeviceCommandVoiceControl

@synthesize voiceText;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self && json) {
        self.voiceText = [json stringForKey:@"voiceText"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    [json setMayBlankString:self.voiceText forKey:@"voiceText"];
    return json;
}

- (BOOL)isEqual:(id)object {
    if(![super isEqual:object]) {
        return NO;
    }
    if([object isKindOfClass:[DeviceCommandVoiceControl class]]) {
        DeviceCommandVoiceControl *control = (DeviceCommandVoiceControl *)object;
        
        if(([XXStringUtils isBlank:self.voiceText] && ![XXStringUtils isBlank:control.voiceText])
           || (![XXStringUtils isBlank:self.voiceText] && [XXStringUtils isBlank:control.voiceText])) {
            return NO;
        }
        
        if(![XXStringUtils isBlank:self.voiceText]) {
            return [self.voiceText isEqualToString:control.voiceText];
        }
    }
    return NO;
}

@end
