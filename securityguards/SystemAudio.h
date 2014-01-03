//
//  SystemAudio.h
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemAudio : NSObject

+ (void)playClassicSmsSound;
+ (void)shake;
+ (void)photoShutter;
+ (void)voiceRecordBegin;
+ (void)voiceRecordEnd;

@end
