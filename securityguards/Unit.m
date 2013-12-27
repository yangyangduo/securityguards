//
//  Unit.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Unit.h"
#import "GlobalSettings.h"

@interface Unit()

@end

@implementation Unit

@synthesize identifier;
@synthesize localPort;
@synthesize localIP;
@synthesize name;
@synthesize status;
@synthesize updateTime;
@synthesize zones;
@synthesize devices;
@synthesize hashCode;

@synthesize avalibleDevicesCount;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.identifier = [json stringForKey:@"_id"];
            
            if(self.identifier != nil) {
                self.identifier = [self.identifier substringToIndex:self.identifier.length-4];
            }
            
            self.localIP = [json stringForKey:@"localIp"];
            self.name = [json stringForKey:@"name"];
            self.localPort = [json integerForKey:@"localPort"];
            self.status = [json stringForKey:@"status"];
            self.hashCode = [json numberForKey:@"hashCode"];
            self.updateTime = [json dateForKey:@"updateTime"];
            
            NSArray *_zones_ = [json notNSNullObjectForKey:@"zones"];
            if(_zones_ != nil) {
                for(int i=0; i<_zones_.count; i++) {
                    NSDictionary *_zone_ = [_zones_ objectAtIndex:i];
                    Zone *zone = [[Zone alloc] initWithJson:_zone_];
                    zone.unit = self;
                    [self.zones addObject:zone];
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:([XXStringUtils isBlank:self.identifier] ? [XXStringUtils emptyString] : [NSString stringWithFormat:@"%@%@", self.identifier, APP_KEY]) forKey:@"_id"];
    
    [json setMayBlankString:self.localIP forKey:@"localIp"];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setInteger:self.localPort forKey:@"localPort"];
    [json setMayBlankString:self.status forKey:@"status"];
    [json setDateLongLongValue:self.updateTime forKey:@"updateTime"];
    
    [json setObject:(self.hashCode == nil ? [NSNumber numberWithInteger:0] : self.hashCode) forKey:@"hashCode"];
    
    // zones ...
    NSMutableArray *_zones_ = [NSMutableArray array];
    for(int i=0; i<self.zones.count; i++) {
        Zone *zone = [self.zones objectAtIndex:i];
        [_zones_ addObject:[zone toJson]];
    }
    [json setObject:_zones_ forKey:@"zones"];
    
    return json;
}

- (NSMutableArray *)zones {
    if(zones == nil) {
        zones = [NSMutableArray array];
    }
    return zones;
}

- (Zone *)zoneForId:(NSString *)_id_ {
    if([XXStringUtils isBlank:_id_]) return nil;
    for(int i=0; i<self.zones.count; i++) {
        Zone *zone = [self.zones objectAtIndex:i];
        if([_id_ isEqualToString:zone.identifier]) {
            return zone;
        }
    }
    return nil;
}

- (Device *)deviceForId:(NSString *)_id_ {
    if([XXStringUtils isBlank:_id_]) return nil;
    for(int i=0; i<self.zones.count; i++) {
        Zone *zone = [self.zones objectAtIndex:i];
        Device *device = [zone deviceForId:_id_];
        if(device != nil) {
            return device;
        }
    }
    return nil;
}

- (NSArray *)devices {
    NSMutableArray *_devices_ = [NSMutableArray array];
    if(self.zones.count != 0) {
        for(int i=0; i<self.zones.count; i++) {
            Zone *zone = [self.zones objectAtIndex:i];
            if(zone.devices != nil && zone.devices.count > 0) {
                [_devices_ addObjectsFromArray:zone.devices];
            }
        }
    }
    return _devices_;
}

- (NSUInteger)avalibleDevicesCount {
    int count = 0;
    for(Device *device in [self devices]) {
        if(device.state == 0) {
            count++;
        }
    }
    return count;
}

@end
