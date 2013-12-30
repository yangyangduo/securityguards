//
//  SpeechRecognitionButton.h
//  SpeechRecognition
//
//  Created by young on 6/19/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#define IFLY_APP_ID            @"522837cb"
#define CONNECTION_TIME_OUT    @"10000"      //Unit is ms


#import <UIKit/UIKit.h>
#import <iflyMSC/IFlySpeechRecognizer.h>

@protocol SpeechRecognitionNotificationDelegate <NSObject>

- (void)recognizeSuccess:(NSString *)result;
- (void)recognizeError:(int)errorCode;

@optional

- (void)beginRecord;
- (void)endRecord;
- (void)recognizeCancelled;
- (void)speakerVolumeChanged:(int)volume;

@end

@interface SpeechRecognitionUtil : NSObject<IFlySpeechRecognizerDelegate>

@property(weak, nonatomic) id<SpeechRecognitionNotificationDelegate> speechRecognitionNotificationDelegate;

/*
 *   iat:     普通文本转写;
 *   search:  热词搜索;
 *   video:   视频音乐搜索;
 *   asr:     命令词识别;
 */
@property(strong, nonatomic) NSString *domain;

//开始录音后用户多久不说话认为此次录音无效  0 - 10000
@property(strong, nonatomic) NSString *vadBos;

//真正有效的开始录音后用户多久不说话认为此次录音结束  0 - 10000
@property(strong, nonatomic) NSString *vadEos;

//采样率 目前支持16000 或 8000
@property(strong, nonatomic) NSString *sampleRate;

//0 或者 1, 0表示返回带标点的文本 1表示返回不带标点的文本
@property(strong, nonatomic) NSString *asrPtt;

/*
 * 是否进行语义处理 0 否 , 1 是
 * 如果需要进行语义处理, 下面的textPlain需要设置成 1
 * 服务端会返回json数据, 再由自己解析
 */
@property(strong, nonatomic) NSString *asrSch;

/*
 * 返回结果是否在内部进行json解析
 * 0 解析， 1不解析
 *
 * 解析后返回的的文本,对于语音等业务的处理我们不需要服务端进行解析
 * 而是由自己来解析
 */
@property(strong, nonatomic) NSString *plainResult;

/* 命令词识别的语法id 只针对 domain 为 asr的应用 */
@property(strong, nonatomic) NSString *grammarID;

+ (SpeechRecognitionUtil *)current;

- (BOOL)startListening;
- (void)stopListening;
- (void)cancel;

@end
