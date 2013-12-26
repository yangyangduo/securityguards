//
//  Zone.h
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Device.h"

@class Unit;

@interface Zone : Entity

@property (strong, nonatomic) Unit *unit;
@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identifier;

- (Device *)deviceForId:(NSString *)_id_;

@end
