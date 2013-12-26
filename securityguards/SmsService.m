//
//  SmsService.m
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SmsService.h"
#import "RestClient.h"

#define SMS_URL  @"http://si.800617.com:4400/SendLenSms.aspx"
#define SMS_UN   @"cshtxx-1"
#define SMS_PWD  @"0830a0"


@implementation SmsService {

}

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:SMS_URL];
    }
    return self;
}

- (void)sendMessage:(NSString *)message for:(NSString *)phoneNumber
            success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"?un=%@&pwd=%@&mobile=%@&msg=%@", SMS_UN, SMS_PWD, phoneNumber,message];
    [self.client getForUrl:url acceptType:@"application/xml" success:s error:f for:t callback:cb];
}

@end
