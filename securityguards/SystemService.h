//
//  SystemService.h
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXStringUtils.h"

@interface SystemService : NSObject

+ (void)dialToMobile:(NSString *)mobile;
+ (void)messageToMobile:(NSString *)mobile withMessage:(NSString *)message;
    
@end
