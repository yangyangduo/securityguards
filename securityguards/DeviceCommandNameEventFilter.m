//
//  DeviceCommandNameEventFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandNameEventFilter.h"

@implementation DeviceCommandNameEventFilter

@synthesize supportedCommandNames = _supportedCommandNames_;

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        if(evt.command != nil) {
            for(int i=0; i<self.supportedCommandNames.count; i++) {
                NSString *commandName = [self.supportedCommandNames objectAtIndex:i];
                if([commandName isEqualToString:evt.command.commandName]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (NSMutableArray *)supportedCommandNames {
    if(_supportedCommandNames_ == nil) {
        _supportedCommandNames_ = [NSMutableArray array];
    }
    return _supportedCommandNames_;
}

@end
