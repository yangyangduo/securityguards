//
//  DeviceCommandNameEventFilter.h
//  SmartHome
//
//  Created by Zhao yang on 12/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEventFilter.h"
#import "DeviceCommandEvent.h"

@interface DeviceCommandNameEventFilter : XXEventFilter

@property (strong, nonatomic) NSMutableArray *supportedCommandNames;

@end
