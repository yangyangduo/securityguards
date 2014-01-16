//
//  Shared.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Shared : NSObject

@property (nonatomic, strong, readonly) AppDelegate *app;

+ (instancetype)shared;

@end
