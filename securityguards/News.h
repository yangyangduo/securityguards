//
//  News.h
//  securityguards
//
//  Created by Zhao yang on 1/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"

@interface News : Entity

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) long long createTime;

@end
