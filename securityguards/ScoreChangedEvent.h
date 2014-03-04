//
// Created by Zhao yang on 3/4/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXEvent.h"
#import "EventNameContants.h"
#import "Unit.h"

@interface ScoreChangedEvent : XXEvent

@property (nonatomic, strong) Score *score;

@end