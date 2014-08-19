//
//  TimingTasksPlanService.m
//  securityguards
//
//  Created by Zhao yang on 1/26/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTasksPlanService.h"
#import "JsonUtils.h"

@implementation TimingTasksPlanService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/schedule", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

- (void)timingTasksPlanForUnitIdentifier:(NSString *)unitIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/list/%@%@?deviceCode=%@&appKey=%@&security=%@",
                     unitIdentifier,
                     APP_KEY,
                     [GlobalSettings defaultSettings].deviceCode,
                     APP_KEY,
                     [GlobalSettings defaultSettings].secretKey];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)saveTimingTasksPlan:(TimingTask *)timingTask success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSDictionary *_timing_task_ = [timingTask toJson];
    NSData *httpBody = [JsonUtils createJsonDataFromDictionary:_timing_task_];
    NSString *url = [NSString stringWithFormat:@"/save?deviceCode=%@&appKey=%@&security=%@",
                     [GlobalSettings defaultSettings].deviceCode,
                     APP_KEY,
                     [GlobalSettings defaultSettings].secretKey];
    [self.client putForUrl:url acceptType:@"text/*" contentType:@"text/html" body:httpBody success:s error:f for:t callback:cb];
}

- (void)updateTimingTasksPlanEnabled:(TimingTask *)timingTask enable:(BOOL)enable success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/update/%@%@/%@?deviceCode=%@&appKey=%@&security=%@&enable=%@",
        timingTask.unitIdentifier, APP_KEY, timingTask.identifier,
        [GlobalSettings defaultSettings].deviceCode, APP_KEY,
        [GlobalSettings defaultSettings].secretKey, enable?@"true":@"false"];
    [self.client putForUrl:url acceptType:@"text/*" contentType:@"text/html" body:nil success:s error:f for:t callback:cb];
}

- (void)deleteTimingTask:(TimingTask *)timingTask success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/%@%@/%@?deviceCode=%@&appKey=%@&security=%@",timingTask.unitIdentifier, APP_KEY, timingTask.identifier, [GlobalSettings defaultSettings].deviceCode, APP_KEY,
                     [GlobalSettings defaultSettings].secretKey];
    [self.client deleteForUrl:url success:s error:f for:t callback:cb];
}

@end
