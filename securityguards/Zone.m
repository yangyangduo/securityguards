//
//  Zone.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Zone.h"

@implementation Zone

@synthesize name;
@synthesize devices;
@synthesize identifier;
@synthesize unit;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.name = [json stringForKey:@"name"];
            self.identifier = [json stringForKey:@"code"];
            NSArray *_devices_ = [json arrayForKey:@"devices"];
            if(_devices_ != nil) {
                for(int i=0; i<_devices_.count; i++) {
                    NSDictionary *_device_ = [_devices_ objectAtIndex:i];
                    Device *device = [[Device alloc] initWithJson:_device_];
                    if(device.isAvailableDevice) {
                        device.zone = self;
                        [self.devices addObject:device];
                    }
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setMayBlankString:self.identifier forKey:@"code"];
    NSMutableArray *_devices_ = [NSMutableArray array];
    for(int i=0; i<self.devices.count; i++) {
        Device *device = [self.devices objectAtIndex:i];
        [_devices_ addObject:[device toJson]];
    }
    [json setObject:_devices_ forKey:@"devices"];
    return json;
}

- (NSMutableArray *)devices {
    if(devices == nil) {
        devices = [NSMutableArray array];
    }
    return devices;
}

- (Device *)deviceForId:(NSString *)_id_ {
    if([XXStringUtils isBlank:_id_]) return nil;
    for(int i=0; i<self.devices.count; i++) {
        Device *device = [self.devices objectAtIndex:i];
        if([_id_ isEqualToString:device.identifier]) {
            return device;
        }
    }
    return nil;
}

- (BOOL)isMasterZone {
    return [self.identifier isEqualToString:@"#MASTER"];
}

@end
