//
//  SpeechSynthesizer.h
//  SpeechRecognition
//
//  Created by young on 7/12/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import "SpeechRecognitionUtil.h"

@protocol SpeechSynthesizerNotificationDelegate <NSObject>

- (void)synthesizerSuccess;
- (void)synthesizerError:(int)errorCode;

@optional



@end

@interface SpeechSynthesizer : NSObject<IFlySpeechSynthesizerDelegate>

/* 语速 0~100 */
@property (strong, nonatomic) NSString *speed;

/* 音量 0~100 */
@property (strong, nonatomic) NSString *volume;

/* 发音者 默认 'xiaoyan' */

@property (strong, nonatomic) NSString *voiceName;

/* 采样率 16000 or 8000 */
@property (strong, nonatomic) NSString *sampleRate;

@property (assign, nonatomic) id<SpeechSynthesizerNotificationDelegate> delegate;

@property (assign, nonatomic) Boolean isSpeaking;

- (void)speakWithString:(NSString *)str;

@end
