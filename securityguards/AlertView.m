//
//  AlertView.m
//  SmartHome
//
//  Created by Zhao yang on 8/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AlertView.h"
#import "XXStringUtils.h"
#import <QuartzCore/QuartzCore.h>

#define DELAY_DURATION          1.0f
#define ANIMATION_DURATION      0.4f
#define BACKGROUND_VIEW_ALPHA   0.8f

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

@implementation AlertView {
    NSTimer *timer;
    UILabel *lblMessage;
    UIImageView *imgTips;
    UIActivityIndicatorView *indicatorView;
    UIView *lockedView;
}

@synthesize alertViewType;
@synthesize alertViewState;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    self.alertViewState = AlertViewStateReady;
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10;
    self.alpha = 0;
    
    if(imgTips == nil) {
        imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        imgTips.center = CGPointMake(self.center.x, 30);
        [self addSubview:imgTips];
    }
    
    if(indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.center = CGPointMake(self.center.x, 30);
        [self addSubview:indicatorView];
    }
    
    if(lblMessage == nil) {
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 130, 21)];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont systemFontOfSize:15.f];
        lblMessage.textColor = [UIColor whiteColor];
        [self addSubview:lblMessage];
    }
}

+ (AlertView *)currentAlertView {
    static AlertView *currentAlertView;
    if(currentAlertView == nil) {
        currentAlertView = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, 140, 88)];
        currentAlertView.center = CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y);
    }
    return currentAlertView;
}

- (void)alertAutoDisappear:(BOOL)autoDisappear lockView:(UIView *)lockView {
    if(self.alertViewState != AlertViewStateReady) return;
    self.alertViewState = AlertViewStateWillAppear;
    if(lockView) {
        lockView.userInteractionEnabled = NO;
        lockedView = lockView;
    }
    [KEY_WINDOW addSubview:self];
    if(self.alertViewType == AlertViewTypeWaitting) {
        if(!indicatorView.isAnimating) {
            [indicatorView startAnimating];
        }
    }
    [UIView animateWithDuration:ANIMATION_DURATION
            animations:^{
                self.alpha = BACKGROUND_VIEW_ALPHA;
            }
            completion:^(BOOL finished) {
                self.alertViewState = AlertViewStateDidAppear;
                if(autoDisappear) {
                    [self delayDismissAlertView];
                }
            }];
}

- (void)delayDismissAlertView {
    timer = [NSTimer scheduledTimerWithTimeInterval:DELAY_DURATION target:self selector:@selector(dismissAlertView) userInfo:nil repeats:NO];
}

- (void)dismissAlertView {
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    if(self.alertViewState == AlertViewStateWillAppear || self.alertViewState == AlertViewStateDidAppear) {
        self.alertViewState = AlertViewStateWillDisappear;
        [UIView animateWithDuration:ANIMATION_DURATION
                animations:^{
                    self.alpha = 0;
                }
                completion:^(BOOL finished) {
                    if(indicatorView.isAnimating) {
                        [indicatorView stopAnimating];
                    }
                    [self removeFromSuperview];
                    if(lockedView) {
                        lockedView.userInteractionEnabled = YES;
                        lockedView = nil;
                    }
                    self.alertViewState = AlertViewStateReady;
                }];
    }
}

- (void)setMessage:(NSString *)message forType:(AlertViewType)type {
    if(message == nil) message = [XXStringUtils emptyString];
    lblMessage.text = [XXStringUtils trim:message];
    alertViewType = type;
    switch (type) {
        case AlertViewTypeNone:
            indicatorView.hidden = YES;
            imgTips.hidden = YES;
            lblMessage.text = [XXStringUtils emptyString];
            break;
        case AlertViewTypeWaitting:
            indicatorView.hidden = NO;
            imgTips.hidden = YES;
            break;
        case AlertViewTypeSuccess:
            indicatorView.hidden = YES;
            imgTips.hidden = NO;
            imgTips.image = [UIImage imageNamed:@"alert_success"];
            break;
        case AlertViewTypeFailed:
            indicatorView.hidden = YES;
            imgTips.hidden = NO;
            imgTips.image = [UIImage imageNamed:@"alert_failed"];
            break;
        default:
            break;
    }
}

@end
