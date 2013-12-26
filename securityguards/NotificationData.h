//
//  NotificationData.h
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface NotificationData : Entity

@property (strong, nonatomic) NSString *masterDeviceCode;
@property (strong, nonatomic) NSString *requestDeviceCode;
@property (strong, nonatomic) NSString *http;
@property (strong, nonatomic) NSString *dataCommandName;
@property (strong, nonatomic) NSMutableArray *cameraPicPaths;

- (BOOL)isCameraData;

@end
