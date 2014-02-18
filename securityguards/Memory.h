//
//  Memory.h
//  securityguards
//
//  Created by Zhao yang on 2/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memory : NSObject

@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSMutableArray *merchandises;

+ (instancetype)memory;

- (void)clearAll;

@end
