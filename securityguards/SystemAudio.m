//
//  SystemAudio.m
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SystemAudio.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SystemAudio

+ (void)playClassicSmsSound {
    AudioServicesPlaySystemSound(1007);
}

+ (void)shake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)photoShutter{
    AudioServicesPlaySystemSound(1108);
}

+ (void)voiceRecordBegin {
    AudioServicesPlaySystemSound(1110);
}

+ (void)voiceRecordEnd {
    AudioServicesPlaySystemSound(1112);
}

@end
