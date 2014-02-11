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

+ (void)printJsonDictionary:(NSDictionary *)dictionary {
    if(dictionary != nil) {
        NSData *_json_data_ = [[self class] createJsonDataFromDictionary:dictionary];
        [[self class] printJsonData:_json_data_];
    }
}

+ (void)printJsonEntity:(Entity *)entity {
    if(entity != nil) {
        NSDictionary *_json_ = [entity toJson];
        NSData *_json_data_ = [[self class] createJsonDataFromDictionary:_json_];
        [[self class] printJsonData:_json_data_];
    }
}

@end
