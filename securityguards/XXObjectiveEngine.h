//
//  XXObjectiveEngine.h
//  securityguards
//
//  Created by Zhao yang on 4/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXObjectiveEngineListener;

@interface XXObjectiveEngine : NSObject

@property (nonatomic, strong, readonly) NSArray *objectiveEngineListeners;

- (void)startEngine;
- (void)stopEngine;

- (void)addObjectiveEngineListener:(id<XXObjectiveEngineListener>)objectiveEngineListener;

@end

@protocol XXObjectiveEngineListener <NSObject>

@end
