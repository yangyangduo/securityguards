//
//  CommunicationMessage.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"
#import "BitUtils.h"
#import "JsonUtils.h"

#define DATA_HEADER_LENGTH   1
#define DATA_LENGTH_LENGTH   4
#define DEVICE_NO_LENGTH     17
#define MD5_LENGTH           16

@interface CommunicationMessage : NSObject

@property (strong, nonatomic) DeviceCommand *deviceCommand;

- (NSData *)generateData;

@end
