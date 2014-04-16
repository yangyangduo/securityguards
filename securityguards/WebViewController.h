//
//  WebViewController.h
//  securityguards
//
//  Created by Zhao yang on 4/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"

typedef NS_ENUM(NSInteger, ContentSourceType) {
    ContentSourceTypeNone,
    ContentSourceTypeUrl,
    ContentSourceTypeLocalHtmlFile,
    ContentSourceTypeHtmlString
};

@interface WebViewController : NavigationViewController<UIWebViewDelegate>

@property (nonatomic, readonly) ContentSourceType contentSourceType;

- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithLocalHtmlFileName:(NSString *)localHtmlFileName;

@end
