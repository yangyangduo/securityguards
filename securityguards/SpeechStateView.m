//
//  SpeechStateView.m
//  securityguards
//
//  Created by Zhao yang on 12/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechStateView.h"
#import "UIColor+MoreColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpeechStateView {
    UILabel *lblTitle;
    UILabel *lblDescription;
}

@synthesize state = _state_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

+ (SpeechStateView *)defaultView {
    static SpeechStateView *defaultView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        defaultView = [[SpeechStateView alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
        defaultView.center = CGPointMake(keyWindow.center.x, keyWindow.center.y);
    });
    return defaultView;
}

- (void)initUI {
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont boldSystemFontOfSize:18.f];
    lblTitle.text = NSLocalizedString(@"please_speaking", @"");
    [self addSubview:lblTitle];
    
    lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, 25)];
    lblDescription.backgroundColor = [UIColor clearColor];
    lblDescription.textAlignment = NSTextAlignmentCenter;
    lblDescription.textColor = [UIColor redColor];
    lblDescription.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:lblDescription];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.f;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5f;
}

- (void)setState:(SpeechViewState)state {
    if(state == SpeechViewStateNone) {
        if(self.superview != nil) {
            [self removeFromSuperview];
        }
    } else {
        if(state == SpeechViewStateSpeaking) {
            lblDescription.text = NSLocalizedString(@"finger_up_cancel_send", @"");
            lblDescription.textColor = [UIColor whiteColor];
        } else if(state == SpeechViewStateWillCancel) {
            lblDescription.text = NSLocalizedString(@"finger_release_cancel_send", @"");
            lblDescription.textColor = [UIColor appRed];
        } else {
    #ifdef DEBUG
            NSLog(@"[Speech State View] Oh my god, unknow state!!!");
    #endif
        }
        
        if(self.superview == nil) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }
}

@end
