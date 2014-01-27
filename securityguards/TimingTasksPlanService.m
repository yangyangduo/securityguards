//
//  TimingTasksPlanService.m
//  securityguards
//
//  Created by Zhao yang on 1/26/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTasksPlanService.h"

@implementation TimingTasksPlanService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/schedule/list", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

- (void)timingTasksPlanForUnitIdentifier:(NSString *)unitIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/%@%@?deviceCode=%@&appKey=%@&security=%@",
                     unitIdentifier,
                     APP_KEY,
                     [GlobalSettings defaultSettings].deviceCode,
                     APP_KEY,
                     [GlobalSettings defaultSettings].secretKey];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

@end
