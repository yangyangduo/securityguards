//
//  ShoppingService.m
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingService.h"

@implementation ShoppingService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/mall", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

- (void)getProductsSuccess:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/product/list?deviceCode=%@&appKey=%@&security=%@", [GlobalSettings defaultSettings].deviceCode, APP_KEY,
        [GlobalSettings defaultSettings].secretKey];
    [self.client getForUrl:url acceptType:@"text/html" success:s error:f for:t callback:cb];
}

@end
