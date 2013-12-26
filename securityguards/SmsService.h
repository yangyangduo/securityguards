//
//  SmsService.h
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceBase.h"

@interface SmsService : ServiceBase

- (void)sendMessage:(NSString *)message for:(NSString *)phoneNumber
            success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb;
@end
