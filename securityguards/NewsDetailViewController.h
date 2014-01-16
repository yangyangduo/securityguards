//
//  NewsDetailViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"
#import "News.h"

@interface NewsDetailViewController : NavigationViewController<UIWebViewDelegate>

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) UIWebView *newsWebView;

- (id)initWithNews:(News *)news;

@end
