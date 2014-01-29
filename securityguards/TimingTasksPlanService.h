//
//  TimingTasksPlanService.h
//  securityguards
//
//  Created by Zhao yang on 1/26/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "TimingTask.h"

@interface TimingTasksPlanService : ServiceBase

- (void)timingTasksPlanForUnitIdentifier:(NSString *)unitIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

- (void)saveTimingTasksPlan:(TimingTask *)timingTask success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

@end
