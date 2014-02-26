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

- (void)postOrder:(NSData *)orderJsonData success:(SEL)s failed:(SEL)f saveContact:(BOOL)saveContact target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/order?deviceCode=%@&appKey=%@&security=%@&saveContact=%@",
                     [GlobalSettings defaultSettings].deviceCode, APP_KEY,
                     [GlobalSettings defaultSettings].secretKey, saveContact ? @"true" : @"false"];
    [self.client postForUrl:url acceptType:@"text/html" contentType:@"text/html" body:orderJsonData success:s error:f for:t callback:cb];
}

- (void)getContactInfoSuccess:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/contact/%@?deviceCode=%@&appKey=%@&security=%@",
                     [NSString stringWithFormat:@"%@%@", [GlobalSettings defaultSettings].deviceCode, APP_KEY],
                     [GlobalSettings defaultSettings].deviceCode, APP_KEY,
                     [GlobalSettings defaultSettings].secretKey];
    [self.client getForUrl:url acceptType:@"text/html" success:s error:f for:t callback:cb];
}

- (void)getProductsSuccess:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/product/list?deviceCode=%@&appKey=%@&security=%@", [GlobalSettings defaultSettings].deviceCode, APP_KEY,
        [GlobalSettings defaultSettings].secretKey];
    [self.client getForUrl:url acceptType:@"text/html" success:s error:f for:t callback:cb];
}

@end
