//
//  UnitManager.h
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"
#import "DeviceStatus.h"
#import "CoreService.h"

@interface UnitManager : NSObject

@property (strong, atomic) NSMutableArray *units;
@property (strong, atomic, readonly) Unit *currentUnit;

+ (instancetype)defaultManager;

/*
 *  Update the new units to memory
 */
- (NSArray *)replaceUnits:(NSArray *)newUnits;

/*
 *  Update unit devices status for a unit
 */
- (void)updateUnitDevices:(NSArray *)devicesStatus forUnit:(NSString *)identifier;

/*
 *  find a unit by unit identifier (code)
 */
- (Unit *)findUnitByIdentifier:(NSString *)identifier;

/*
 *  remove a unit by identifier
 */
- (void)removeUnitByIdentifier:(NSString *)identifier;

/*
 *  change the current unit vai unit identifier (code)
 */
- (void)changeCurrentUnitTo:(NSString *)unitIdentifier;


/*
 *  get all units identifier to a array
 */
- (NSArray *)allUnitsIdentifierAsArray;


/* 
 *  load units from disk file
 */
- (void)loadUnitsFromDisk;

/*
 *
 */
- (NSArray *)updateUnit:(Unit *)unit;


/*
 *
 */
- (BOOL)hasUnit;


/*
 * clear
 */
- (void)clear;


/*
 *  sync memory units to disk file
 */
- (void)syncUnitsToDisk;


@end
