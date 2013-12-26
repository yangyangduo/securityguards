//
//  CameraPicPath.m
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraPicPath.h"

@implementation CameraPicPath

@synthesize path;
@synthesize name;
@synthesize host;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.path = [json stringForKey:@"path"];
        self.name = [json stringForKey:@"name"];
        self.host = [json stringForKey:@"host"];
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setNoBlankString:self.path forKey:@"path"];
    [json setNoBlankString:self.name forKey:@"name"];
    [json setNoBlankString:self.host forKey:@"host"];
    return json;
}

@end
