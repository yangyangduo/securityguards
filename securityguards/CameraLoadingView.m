//
//  CameraLoadingView.m
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraLoadingView.h"
#import "XXStringUtils.h"

@implementation CameraLoadingView {
    UIActivityIndicatorView *indicatorView;
    UILabel *lblTitle;
    UIImageView *imgView;
}

@synthesize message = _message_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

+ (CameraLoadingView *)viewWithPoint:(CGPoint)point {
    CameraLoadingView *view = [[CameraLoadingView alloc] initWithFrame:CGRectMake(point.x, point.y, 180, 50)];
    return view;
}

- (void)initDefaults {
    
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    
    if(indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 3, 44, 44)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:indicatorView];
    }
    
    if(imgView == nil) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 44, 44)];
        imgView.image = [UIImage imageNamed:@"alert_failed.png"];
        [self addSubview:imgView];
    }
    
    if(lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 110, 44)];
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:lblTitle];
    }
    
    [self show];
}

- (void)show {
    self.hidden = NO;
    imgView.hidden = YES;
    lblTitle.text = NSLocalizedString(@"loading", @"");
    if(!indicatorView.isAnimating) {
        [indicatorView startAnimating];
    }
}

- (void)hide {
    if(indicatorView.isAnimating) {
        [indicatorView stopAnimating];
    }
    self.hidden = YES;
}

- (void)showError {
    imgView.hidden = NO;
    self.hidden = NO;
    if(indicatorView.isAnimating) {
        [indicatorView stopAnimating];
    }
    [self setMessage:NSLocalizedString(@"connect_failed", @"")];
}

- (void)setMessage:(NSString *)message {
    _message_ = message;
    if([XXStringUtils isBlank:_message_]) {
        lblTitle.text = [XXStringUtils emptyString];
    } else {
        lblTitle.text = _message_;
    }
}

@end
