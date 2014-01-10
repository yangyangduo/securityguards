//
//  NewsService.m
//  securityguards
//
//  Created by Zhao yang on 1/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewsService.h"

@implementation NewsService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/news/list", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

- (void)getTopNewsWithSuccess:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    [self.client getForUrl:nil acceptType:@"text/*" success:s error:f for:t callback:cb];
}

@end
