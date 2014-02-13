//
//  DeviceService.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeviceService.h"
#import "Zone.h"
#import "Unit.h"

@implementation DeviceService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/device", [GlobalSettings defaultSettings].restAddress]];
    }
    return self;
}

- (void)updateDeviceName:(NSString *)name status:(int)status type:(int)type for:(Device *)device success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSMutableString *url = [NSMutableString stringWithFormat:
                     @"/update/%@%@/%@?deviceCode=%@&appKey=%@&security=%@&name=%@",
                     device.zone.unit.identifier, APP_KEY, device.identifier,
                     [GlobalSettings defaultSettings].deviceCode, APP_KEY,
                     [GlobalSettings defaultSettings].secretKey,
                     [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(status != -1000) {
        [url appendString:[NSString stringWithFormat:@"&status=%d", status]];
    }
    
    if(type != -1000) {
        [url appendString:[NSString stringWithFormat:@"&type=%d", type]];
    }
    
    [self.client putForUrl:url acceptType:@"text/*" contentType:@"text/html" body:nil success:s error:f for:t callback:cb];
}

@end
