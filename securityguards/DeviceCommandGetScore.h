//
// Created by Zhao yang on 3/4/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"

@interface DeviceCommandGetScore : DeviceCommand

@property (nonatomic) int score;
@property (nonatomic) int rankings;
@property (nonatomic, strong) NSDate *scoreTime;

@end