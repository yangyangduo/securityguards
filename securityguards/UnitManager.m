//
//  UnitManager.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitManager.h"
#import "CurrentUnitChangedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "GlobalSettings.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"familyguards-units"]

@implementation UnitManager {
    NSString *currentUnitIdentifier;
}

@synthesize units;
@synthesize currentUnit;

+ (instancetype)defaultManager {
    static UnitManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(self.units == nil) {
        self.units = [NSMutableArray array];
    }
}

#pragma mark -
#pragma mark units

- (NSArray *)updateUnit:(Unit *)unit {
    @synchronized(self) {
        if(unit == nil) return self.units;
        if(self.units.count == 0) {
            [self.units addObject:unit];
        } else {
            int replaceIndex = -1;
            for(int i=0; i<self.units.count; i++) {
                Unit *oldUnit = [self.units objectAtIndex:i];
                if([oldUnit.identifier isEqualToString:unit.identifier]) {
                    replaceIndex = i;
                    if([XXStringUtils isBlank:unit.status]) {
                        // this unit should be returned by internal network when the status is blank
                        // so we doesn't need to change unit name
                        // and also the status must be 'online'
                        unit.name = oldUnit.name;
                        unit.status = @"在线";

                        // new unit doesn't contains info about score, timing task plan && refresh date
                        unit.score = oldUnit.score;
                        unit.timingTasksPlan = oldUnit.timingTasksPlan;
                        unit.timingTasksPlanLastRefreshDate = oldUnit.timingTasksPlanLastRefreshDate;
                        unit.sensors = oldUnit.sensors;
                    }
                    break;
                }
            }
            if(replaceIndex != -1) {
                // update unit
                [self.units replaceObjectAtIndex:replaceIndex withObject:unit];
            } else {
                // the unit isn't existed, need append to units list
                [self.units addObject:unit];
            }
        }
        
        if([XXStringUtils isBlank:currentUnitIdentifier]
           || ![currentUnitIdentifier isEqualToString:unit.identifier]) {
            
            // set the unit to current unit
            currentUnitIdentifier = unit.identifier;
            
            [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:currentUnitIdentifier triggeredBy:TriggeredByGetUnitsCommand]];
        }
        
        return self.units;
    }
}

- (NSArray *)replaceUnits:(NSArray *)newUnits {
    @synchronized(self) {
        // fill may lost info for each unit
        if(newUnits != nil) {
            for(int i=0; i<newUnits.count; i++) {
                Unit *_new_unit_ = [newUnits objectAtIndex:i];
                [self fillLostUnitInfoFromOldUnitForNewUnit:_new_unit_];
            }
        }

        [self.units removeAllObjects];
        if(newUnits != nil) {
            [self.units addObjectsFromArray:newUnits];    
        }
        
        if(self.units.count > 0) {
            Unit *firstUnit = [self.units objectAtIndex:0];
            [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:firstUnit.identifier triggeredBy:TriggeredByGetUnitsCommand]];
        } else {
            [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:[XXStringUtils emptyString] triggeredBy:TriggeredByGetUnitsCommand]];
        }
        
        return self.units;
    }
}

- (void)fillLostUnitInfoFromOldUnitForNewUnit:(Unit *)newUnit {
    if(newUnit == nil) return;
    Unit *oldUnit = [self findUnitByIdentifierInternal:newUnit.identifier];
    if(oldUnit != nil) {
        newUnit.score = oldUnit.score;
        newUnit.sensors = oldUnit.sensors;
        newUnit.timingTasksPlan = oldUnit.timingTasksPlan;
        newUnit.timingTasksPlanLastRefreshDate = oldUnit.timingTasksPlanLastRefreshDate;
    }
}

- (BOOL)hasUnit {
    @synchronized(self) {
        if(self.units == nil) return NO;
        return self.units.count > 0;
    }
}

- (void)updateUnitDevices:(NSArray *)devicesStatus forUnit:(NSString *)identifier {
    @synchronized(self) {
        if(devicesStatus == nil || devicesStatus.count == 0) return;
        Unit *unit = [self findUnitByIdentifierInternal:identifier];
        if(unit != nil && unit.devices != nil && unit.devices.count > 0) {
            for(DeviceStatus *ds in devicesStatus) {
                for(Device *device in unit.devices) {
                    if([ds.deviceIdentifer isEqualToString:device.identifier]) {
                        device.state = ds.state;
                        device.status = ds.status;
                        break;
                    }
                }
            }
        }
    }
}

- (Unit *)findUnitByIdentifier:(NSString *)identifier {
    @synchronized(self) {
        return [self findUnitByIdentifierInternal:identifier];
    }
}

- (void)removeUnitByIdentifier:(NSString *)identifier {
    @synchronized(self) {
        if([XXStringUtils isBlank:identifier]) return;
        if(self.units == nil || self.units.count == 0) return;
        
        int index = -1;
        for(int i=0; i<self.units.count; i++) {
            Unit *u = [self.units objectAtIndex:i];
            if([u.identifier isEqualToString:identifier]) {
                index = i;
                break;
            }
        }
        if(index != -1) {
            [self.units removeObjectAtIndex:index];
        }
        
        if([currentUnitIdentifier isEqualToString:identifier]) {
            currentUnitIdentifier = [XXStringUtils emptyString];
            if(self.units.count > 0) {
                Unit *firstUnit = [self.units objectAtIndex:0];
                currentUnitIdentifier = firstUnit.identifier;
                [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:firstUnit.identifier triggeredBy:TriggeredByGetUnitsCommand]];
            } else {
                [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:[XXStringUtils emptyString] triggeredBy:TriggeredByGetUnitsCommand]];
            }
        }
    }
}

- (Unit *)findUnitByIdentifierInternal:(NSString *)identifier {
    if([XXStringUtils isBlank:identifier]) return nil;
    if(self.units == nil || self.units.count == 0) return nil;
    for(Unit *u in self.units) {
        if([u.identifier isEqualToString:identifier]) {
            return u;
        }
    }
    return nil;
}

- (NSArray *)allUnitsIdentifierAsArray {
    @synchronized(self) {
        NSMutableArray *ids = [NSMutableArray array];
        if(self.units == nil || self.units.count == 0) return ids;
        for(Unit *unit in self.units) {
            [ids addObject:unit.identifier];
        }
        return ids;
    }
}

- (Unit *)currentUnit {
    @synchronized(self) {
        if(self.units.count == 0) {
            currentUnitIdentifier = nil;
            return nil;
        }
        
        if([XXStringUtils isBlank:currentUnitIdentifier]) {
            Unit *firstUnit = [self.units objectAtIndex:0];
            currentUnitIdentifier = firstUnit.identifier;
            return firstUnit;
        }
        
        // current unit id is not empty
        // but this unit id is not exist in local units list
        // need again to return index 0 of units
        
        Unit *u = [self findUnitByIdentifierInternal:currentUnitIdentifier];
        if(u == nil) {
            Unit *firstUnit = [self.units objectAtIndex:0];
            currentUnitIdentifier = firstUnit.identifier;
            u = firstUnit;
        }
        return u;
    }
}

- (void)changeCurrentUnitTo:(NSString *)unitIdentifier {
    @synchronized(self) {
        if([XXStringUtils isBlank:unitIdentifier] && [XXStringUtils isBlank:currentUnitIdentifier]) {
            return;
        } else if(![XXStringUtils isBlank:unitIdentifier] && ![XXStringUtils isBlank:currentUnitIdentifier]) {
            if([unitIdentifier isEqualToString:currentUnitIdentifier]) {
                return;
            }
        }
        currentUnitIdentifier = unitIdentifier;
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:
            [[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:unitIdentifier triggeredBy:TriggeredByManual]];
    }
}

#pragma mark -
#pragma mark units file manager

- (void)syncUnitsToDisk {
    @synchronized(self) {
        @try {
            BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
            if(!directoryExists) {
                NSError *error;
                BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
                if(!createDirSuccess) {
#ifdef DEBUG
                    NSLog(@"[UNIT MANAGER] 创建主控文件目录失败 [%@]", error.description);
#endif
                    return;
                }
            }

            NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [GlobalSettings defaultSettings].account]];
            
            if(self.units == nil || self.units.count == 0) {
                BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if(exists) {
                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
#ifdef DEBUG
                    if(error) {
                        NSLog(@"[UNIT MANAGER] 从硬盘中删除主控文件失败 [%@]", error.description);
                    }
#endif
                }
                return;
            }

            NSMutableArray *unitsToSave = [NSMutableArray array];
            for(Unit *unit in self.units) {
                [unitsToSave addObject:[unit toJson]];
            }
            
            NSDictionary *json = @{
                                   @"units" : unitsToSave,
                                   @"currentUnitIdentifier" : (currentUnitIdentifier ? currentUnitIdentifier : @"")
                                   };
            
            NSData *data = [JsonUtils createJsonDataFromDictionary:json];
            
            BOOL success = [data writeToFile:filePath atomically:YES];
            if(!success) {
#ifdef DEBUG
                NSLog(@"[UNIT MANAGER] 保存所有主控列表失败了");
#endif
            }
        }
        @catch (NSException *exception) {
#ifdef DEBUG
            NSLog(@"[UNIT MANAGER] 保存所有主控出异常了 [%@]", exception.reason);
#endif
        }
        @finally {
        }
    }
}

- (void)loadUnitsFromDisk {
    @synchronized(self) {
        NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [GlobalSettings defaultSettings].account]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
            NSArray *_units_ = [json objectForKey:@"units"];
            NSString *_currentUnitIdentifier = [json stringForKey:@"currentUnitIdentifier"];
            
            if(_units_ != nil) {
                NSMutableArray *newUnits = [NSMutableArray array];
                for(NSDictionary *_unit in _units_) {
                    [newUnits addObject:[[Unit alloc] initWithJson:_unit]];
                }
                [self.units removeAllObjects];
                [self.units addObjectsFromArray:newUnits];
                
                if(self.units.count > 0) {
                    Unit *selectedUnit;
                    if(![XXStringUtils isBlank:_currentUnitIdentifier]) {
                        for(Unit *u in self.units) {
                            if([u.identifier isEqualToString:_currentUnitIdentifier]) {
                                selectedUnit = u;
                                currentUnitIdentifier = selectedUnit.identifier;
                                break;
                            }
                        }
                    }
                    
                    if(selectedUnit == nil) {
                        selectedUnit = [self.units objectAtIndex:0];
                        currentUnitIdentifier = selectedUnit.identifier;
                    }

                    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:currentUnitIdentifier triggeredBy:TriggeredByReadDisk]];
                } else {
                    currentUnitIdentifier = nil;
                    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[CurrentUnitChangedEvent alloc] initWithCurrentIdentifier:[XXStringUtils emptyString] triggeredBy:TriggeredByReadDisk]];
                }
                return;
            } else {
                currentUnitIdentifier = nil;
            }
        }
        [self.units removeAllObjects];
    }
}

- (void)clear {
    @synchronized(self) {
        currentUnitIdentifier = nil;
        currentUnit = nil;
        if(self.units != nil && self.units.count > 0) {
            [self.units removeAllObjects];
        }
#ifdef DEBUG
        NSLog(@"[UNIT MANAGER] 清理所有主控");
#endif
    }
}

@end
