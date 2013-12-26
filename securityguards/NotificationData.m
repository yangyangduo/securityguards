//
//  NotificationData.m
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationData.h"
#import "CameraPicPath.h"

@implementation NotificationData

@synthesize masterDeviceCode;
@synthesize requestDeviceCode;
@synthesize dataCommandName;
@synthesize cameraPicPaths;
@synthesize http;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json) {
            self.masterDeviceCode = [json stringForKey:@"masterDeviceCode"];
            self.dataCommandName = [json stringForKey:@"_className"];
            self.requestDeviceCode = [json stringForKey:@"requestDeviceCode"];
            self.http = [json stringForKey:@"http"];
            NSArray *_pics_ = [json arrayForKey:@"cameraPicPaths"];
            if(_pics_ != nil) {
                for(NSDictionary *pic in _pics_) {
                    CameraPicPath *cpp = [[CameraPicPath alloc] initWithJson:pic];
                    if(cpp != nil) {
                        [self.cameraPicPaths addObject:cpp];
                    }
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setMayBlankString:self.masterDeviceCode forKey:@"masterDeviceCode"];
    [json setMayBlankString:self.dataCommandName forKey:@"_className"];
    [json setMayBlankString:self.requestDeviceCode forKey:@"requestDeviceCode"];
    [json setMayBlankString:self.http forKey:@"http"];
    
    if(self.cameraPicPaths.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for(CameraPicPath *cpp in self.cameraPicPaths) {
            [arr addObject:[cpp toJson]];
        }
        [json setObject:arr forKey:@"cameraPicPaths"];
    }
    
    return json;
}

- (NSMutableArray *)cameraPicPaths {
    if(cameraPicPaths == nil) {
        cameraPicPaths = [NSMutableArray array];
    }
    return cameraPicPaths;
}

- (BOOL)isCameraData {
    if(self.dataCommandName != nil) {
        if([self.dataCommandName isEqualToString:@"WarningMessageCommand"]) {
            if(self.cameraPicPaths.count != 0) {
                return YES;
            }
        }
    }
    return NO;
}

@end
