//
//  SpeechSynthesizer.m
//  SpeechRecognition
//
//  Created by young on 7/12/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "SpeechSynthesizer.h"

@implementation SpeechSynthesizer {
    IFlySpeechSynthesizer *speechSynthesizer;
}

@synthesize sampleRate;
@synthesize speed;
@synthesize voiceName;
@synthesize volume;
@synthesize isSpeaking;
@synthesize delegate;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(speechSynthesizer == nil) {
        NSString *initString = [NSString stringWithFormat:@"appid=%@,timeout=%@", IFLY_APP_ID, CONNECTION_TIME_OUT];
        speechSynthesizer = [IFlySpeechSynthesizer createWithParams:initString delegate:self];
    }
    self.sampleRate = @"8000";
    self.speed = @"50";
    self.voiceName = @"xiaoyan";
    self.volume = @"50";
    self.isSpeaking = NO;
}

- (void)speakWithString:(NSString *)str {
    if(self.isSpeaking) return;
    [speechSynthesizer setParameter:@"sample_rate" value:self.sampleRate];
    [speechSynthesizer setParameter:@"speed" value:self.speed];
    [speechSynthesizer setParameter:@"voice_name" value:self.voiceName];
    [speechSynthesizer setParameter:@"volume" value:self.volume];
    [speechSynthesizer startSpeaking:str];
    self.isSpeaking = YES;
}

- (void)stopSpeaking {
    [speechSynthesizer stopSpeaking];
}

- (void)pauseSpeaking {
    [speechSynthesizer pauseSpeaking];
}

- (void)resumeSpeaking {
    [speechSynthesizer resumeSpeaking];
}

#pragma mark Speech Synthesizer Delegate
#pragma mark -

/**
 *  开始播放
 */
- (void) onSpeakBegin {
    
}

/**
 * 缓冲进度
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    NSLog(@"cached %d", progress);
}

/**
 * 播放进度
 */
- (void) onSpeakProgress:(int) progress {
    NSLog(@"play %d", progress);
}

/**
 * 暂停播放
 */
- (void) onSpeakPaused {
    
}

/**
 * 恢复播放
 */
- (void) onSpeakResumed {
    
}

/**
 * 正在取消
 */
- (void) onSpeakCancel {
    if(self.delegate != nil) {
        
    }
}

/**
 * 结束回调
 */
- (void) onCompleted:(IFlySpeechError*) error {
    if(self.delegate != nil) {
        if(error.errorCode == 0) {
            if([self.delegate respondsToSelector:@selector(synthesizerSuccess)]) {
                [self.delegate synthesizerSuccess];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(synthesizerError:)]) {
                [self.delegate synthesizerError:error.errorCode];
            }
        }
    }
    self.isSpeaking = NO;
}

@end
