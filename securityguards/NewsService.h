//
//  NewsService.h
//  securityguards
//
//  Created by Zhao yang on 1/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "News.h"

@interface NewsService : ServiceBase

- (void)getTopNews;
- (void)getNewsBefore:(News *)news;

@end
