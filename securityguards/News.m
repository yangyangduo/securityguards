//
//  News.m
//  securityguards
//
//  Created by Zhao yang on 1/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "News.h"

@implementation News

@synthesize identifier;
@synthesize title;
@synthesize contentUrl;
@synthesize imageUrl;
@synthesize createTime;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    return json;
}

@end
