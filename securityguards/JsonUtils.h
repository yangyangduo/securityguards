//
//  JsonUtils.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface JsonUtils : NSObject

+ (id)createDictionaryFromJson:(NSData *)json;
+ (NSData *)createJsonDataFromDictionary:(NSDictionary *)dictionary;

+ (void)printJsonData:(NSData *)data;
+ (void)printJsonEntity:(Entity *)entity;
+ (void)printJsonDictionary:(NSDictionary *)dictionary;

@end
