//
//  DeviceCommandUpdateDevice.m
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateDevice.h"

@implementation DeviceCommandUpdateDevice

@synthesize executions = _executions_;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    [json setNoNilObject:self.executions forKey:@"executions"];
    return json;
}

- (NSMutableArray *)executions {
    if(_executions_ == nil) {
        _executions_ = [[NSMutableArray alloc] init];
    }
    return _executions_;
}

- (void)addCommandString:(NSString *)commandStr {
    if(![XXStringUtils isBlank:commandStr]) {
        [self.executions addObject:commandStr];
    }
}

- (BOOL)isEqual:(id)object {
    return NO;
}

@end
