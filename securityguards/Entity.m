//
//  Entity.m
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Entity.h"

@implementation Entity

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    return [NSMutableDictionary dictionary];
}

@end
