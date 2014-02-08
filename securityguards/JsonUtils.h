//
//  JsonUtils.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+ (id)createDictionaryFromJson:(NSData *)json;
+ (NSData *)createJsonDataFromDictionary:(NSDictionary *)dictionary;

+ (void)printJsonData:(NSData *)data;

@end
