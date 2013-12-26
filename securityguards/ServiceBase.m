//
//  ServiceBase.m
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"

@implementation ServiceBase

@synthesize client;

- (void)setupWithUrl:(NSString *)url {
    client = [[RestClient alloc] initWithBaseUrl:url];
}

- (void)setupWithUrl:(NSString *)url userName:(NSString *)u password:(NSString *)p {
    client = [[RestClient alloc] initWithBaseUrl:url authName:u authPassword:p authType:AuthenticationTypeBasic];
}

@end
