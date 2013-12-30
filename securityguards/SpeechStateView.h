//
//  SpeechStateView.h
//  securityguards
//
//  Created by Zhao yang on 12/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, SpeechViewState) {
    SpeechViewStateNone,
    SpeechViewStateSpeaking,
    SpeechViewStateWillCancel
};

@interface SpeechStateView : UIView

@property (nonatomic, assign) SpeechViewState state;

+ (SpeechStateView *)defaultView;

- (void)setState:(SpeechViewState)state andVolumn:(int)volumn;

@end
