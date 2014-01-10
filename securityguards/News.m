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
        self.identifier = [json noNilStringForKey:@"a"];
        self.title = [json noNilStringForKey:@"b"];
        self.imageUrl = [json noNilStringForKey:@"c"];
        self.contentUrl = [json noNilStringForKey:@"d"];
        self.createTime = [json longlongForKey:@"e"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.identifier forKey:@"a"];
    [json setMayBlankString:self.title forKey:@"b"];
    [json setMayBlankString:self.imageUrl forKey:@"c"];
    [json setMayBlankString:self.contentUrl forKey:@"d"];
    [json setLongLong:self.createTime forKey:@"e"];
    return json;
}

@end
