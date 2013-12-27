//
//  ServiceBase.h
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"
#import "RestClient.h"

@interface ServiceBase : NSObject

@property (strong, nonatomic) RestClient *client;

- (void)setupWithUrl:(NSString *)url;
- (void)setupWithUrl:(NSString *)url userName:(NSString *)u password:(NSString *)p;

@end
