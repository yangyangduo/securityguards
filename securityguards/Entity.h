//
//  Entity.h
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

@interface Entity : NSObject

- (id)initWithJson:(NSDictionary *)json;
- (NSMutableDictionary *)toJson;

@end
