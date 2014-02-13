//
//  DeviceService.h
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "Device.h"

@interface DeviceService : ServiceBase

- (void)updateDeviceName:(NSString *)name status:(int)status type:(int)type for:(Device *)device success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;

@end
