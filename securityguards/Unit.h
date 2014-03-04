//
//  Unit.h
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Zone.h"
#import "Entity.h"
#import "Sensor.h"

@interface Score : Entity

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int rankings;
@property (nonatomic, strong) NSDate *scoreDate;

- (BOOL)hasValue;

- (BOOL)needRefresh;

- (NSString *)scoreDateAsFormattedString;
- (int)nextRefreshMinutes;

@end


@interface Unit : Entity

// basic info
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *localIP;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSDate *updateTime;
@property (strong, nonatomic) NSNumber *hashCode;
@property (assign, nonatomic) unsigned int localPort;

// zone's and device's
@property (strong, nonatomic) NSMutableArray *zones;

// readonly property
@property (assign, nonatomic, readonly) BOOL isOnline;
@property (assign, nonatomic, readonly) NSUInteger avalibleDevicesCount;
@property (strong, nonatomic, readonly) NSArray *devices;


// ... extensions below ...


// persist to disk
@property (strong, nonatomic) Score *score;


// in memory only
@property (strong, nonatomic) NSMutableArray *timingTasksPlan;
@property (strong, nonatomic) NSDate *timingTasksPlanLastRefreshDate;
@property (strong, nonatomic) NSArray *sensors;


// methods

- (Zone *)zoneForId:(NSString *)_id_;
- (Device *)deviceForId:(NSString *)_id_;
- (Zone *)findMasterZone;
- (Zone *)findSlaveZone;

@end


