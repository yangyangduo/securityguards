//
//  DeviceStatus.h
//  SmartHome
//
//  Created by Zhao yang on 9/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface DeviceStatus : Entity

@property (strong, nonatomic) NSString *deviceIdentifer;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger status;


@end
