//
//  JsonUtils.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "JsonUtils.h"

@implementation JsonUtils

+ (id)createDictionaryFromJson:(NSData *)json {
    if(json == nil) return nil;
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&error];
    if(object != nil && error == nil) {
        return object;
    }
    return nil;
}

+ (NSData *)createJsonDataFromDictionary:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error) return nil;
    return json;
}

+ (void)printJsonData:(NSData *)data {
    if(data != nil) {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[Printer:] %@", json);
    }
}

@end
