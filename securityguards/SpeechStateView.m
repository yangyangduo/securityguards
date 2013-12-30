//
//  SpeechStateView.m
//  securityguards
//
//  Created by Zhao yang on 12/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechStateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpeechStateView {
    UIImageView *imgState;
    UILabel *lblTitle;
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
        defaultView = [[SpeechStateView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    });
    return defaultView;
}

- (void)initUI {
    imgState = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:imgState];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:lblTitle];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5f;
}

- (void)setState:(SpeechViewState)state {
    if(state == SpeechViewStateNone) {
        if(self.superview != nil) {
            [self removeFromSuperview];
        }
    } else {
        if(self.superview == nil) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
        if(state == SpeechViewStateSpeaking) {
            
        } else if(state == SpeechViewStateWillCancel) {
            
        } else {
    #ifdef DEBUG
            NSLog(@"[Speech State View] Oh my god, unknow state!!!");
    #endif
        }
    }
}

- (void)setState:(SpeechViewState)state andVolumn:(int)volumn {
    self.state = state;
}

@end
