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
        [self setupWithUrl:[NSString stringWithFormat:@"%@/mgr/acc", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

@end
