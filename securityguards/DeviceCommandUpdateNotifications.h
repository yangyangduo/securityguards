//
//  DeviceCommandUpdateNotifications.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "SMNotification.h"

@interface DeviceCommandUpdateNotifications : DeviceCommand

@property (strong, nonatomic) NSMutableArray *notifications;

@end
