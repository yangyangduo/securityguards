//
//  Unit.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Unit.h"
#import "GlobalSettings.h"
#import "XXDateFormatter.h"

#define SCORE_REFRESH_HOUR 4

@interface Unit()

@end

@implementation Unit

@synthesize score = _score_;
@synthesize identifier;
@synthesize localPort;
@synthesize localIP;
@synthesize name;
@synthesize status;
@synthesize updateTime;
@synthesize zones;
@synthesize devices;
@synthesize hashCode;

@synthesize sensors;

@synthesize timingTasksPlan = _timingTasksPlan_;
@synthesize timingTasksPlanLastRefreshDate;
@synthesize isOnline;
@synthesize avalibleDevicesCount;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            // init basic info
            self.identifier = [json stringForKey:@"_id"];
            if(self.identifier != nil) {
                self.identifier = [self.identifier substringToIndex:self.identifier.length - 4];
            }
            self.localIP = [json stringForKey:@"localIp"];
            self.name = [json stringForKey:@"name"];
            self.localPort = [json intForKey:@"localPort"];
            self.status = [json stringForKey:@"status"];
            self.hashCode = [json numberForKey:@"hashCode"];
            self.updateTime = [json dateForKey:@"updateTime"];

            // init score's detail
            NSDictionary *_score_json_ = [json notNSNullObjectForKey:@"score"];
            if(_score_json_ != nil) {
                self.score = [[Score alloc] initWithJson:_score_json_];
            }

            // init zones && devices
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

    // set basic info
    [json setObject:([XXStringUtils isBlank:self.identifier] ?
            [XXStringUtils emptyString] : [NSString stringWithFormat:@"%@%@", self.identifier, APP_KEY]) forKey:@"_id"];
    [json setMayBlankString:self.localIP forKey:@"localIp"];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setInteger:self.localPort forKey:@"localPort"];
    [json setMayBlankString:self.status forKey:@"status"];
    [json setDateLongLongValue:self.updateTime forKey:@"updateTime"];
    [json setObject:(self.hashCode == nil ? [NSNumber numberWithInteger:0] : self.hashCode) forKey:@"hashCode"];

    // set score ...
    if([self.score hasValue]) {
        [json setNoNilObject:[self.score toJson] forKey:@"score"];
    }

    // set zones device's ...
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

- (Zone *)findMasterZone {
    return [self zoneForId:@"#MASTER"];
}

- (Zone *)findSlaveZone {
    return [self zoneForId:@"#SLAVE"];
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

- (NSMutableArray *)timingTasksPlan {
    if(_timingTasksPlan_ == nil) {
        _timingTasksPlan_ = [NSMutableArray array];
    }
    return _timingTasksPlan_;
}

- (BOOL)isOnline {
    return [@"在线" isEqualToString:self.status];
}

- (Score *)score {
    if(_score_ == nil) {
        _score_ = [[Score alloc] init];
    }
    return _score_;
}

@end

@implementation Score

@synthesize score;
@synthesize rankings;
@synthesize scoreDate;

- (id)init {
    self = [super init];
    if(self) {
        self.score = -1;
        self.rankings = -1;
    }
    return self;
}

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.score = [json intForKey:@"score"];
        self.rankings = [json intForKey:@"rankings"];
        self.scoreDate = [json dateWithTimeIntervalSince1970ForKey:@"scoreDate"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setInteger:self.score forKey:@"score"];
    [json setInteger:self.rankings forKey:@"rankings"];
    [json setDateUsinghTimeIntervalSince1970:self.scoreDate forKey:@"scoreDate"];
    return json;
}

- (BOOL)hasValue {
    if(self.score == -1 && self.rankings == -1 && self.scoreDate == nil) return NO;
    return YES;
}

- (BOOL)needRefresh {
    if(self.scoreDate == nil) return YES;
    if(abs(self.scoreDate.timeIntervalSinceNow) >= SCORE_REFRESH_HOUR * 60 * 60) {
        return YES;
    }
    return NO;
}

- (int)nextRefreshMinutes {
    if(self.scoreDate == nil) return 0;
    return SCORE_REFRESH_HOUR * 60 - abs(self.scoreDate.timeIntervalSinceNow) / 60;
}

- (NSString *)scoreDateAsFormattedString {
    if(self.scoreDate == nil) return [XXStringUtils emptyString];
    return [XXDateFormatter dateToString:self.scoreDate format:@"MM-dd HH:mm"];
}

@end
