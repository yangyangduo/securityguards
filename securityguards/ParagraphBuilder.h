//
//  ParagraphBuilder.h
//  SpeechRecognition
//
//  Created by young on 6/27/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TextContainerView.h"

typedef NS_ENUM(uint8_t, TEXT_ALIGN) {
    TEXT_ALIGN_LEFT        =    0,
    TEXT_ALIGN_RIGHT       =    1,
    TEXT_ALIGN_CENTER      =    2,
    TEXT_ALIGN_JUSTIFIED   =    3,         //充满整行
    TEXT_ALIGN_NATURAL     =    4          //默认， 自然方式对齐
};

typedef NS_ENUM(uint8_t, LINE_BREAK_MODE) {
    LINE_BREAK_MODE_WORD_WRAPPING         =   0,      //出现在单词边界时起作用，如果该单词不在能在一行里显示时，整体换行。此为段的默认值。
    LINE_BREAK_MODE_CHAR_WRAPPING         =   1,      //当一行中最后一个位置的大小不能容纳一个字符时，才进行换行。
    LINE_BREAK_MODE_CLIPPING              =   2,      //超出画布边缘部份将被截除。
    LINE_BREAK_MODE_TRUNCATING_HEAD       =   3,      //截除前面部份，只保留后面一行的数据。前部份以...代替。
    LINE_BREAK_MODE_TRUNCATING_TAIL       =   4,      //截除后面部份，只保留前面一行的数据，后部份以...代替。
    LINE_BREAK_MODE_TRUNCATING_MIDDLE     =   5       //在一行中显示段文字的前面和后面文字，中间文字使用...代替。
};

@interface ParagraphBuilder : NSObject

@property(assign, nonatomic) BOOL autoFitWidth;
@property(assign, nonatomic) BOOL autoFitHeight;

- (void)addParagraphWithAttributedString:
        (NSMutableAttributedString *)str lineSpace:(CGFloat)ls
        textAlign:(TEXT_ALIGN)ta /*firstLineIndent:(CGFloat)fli
        headIndent:(CGFloat)hi*/ lineBreakMode:(LINE_BREAK_MODE)lbm
        paragraphSpace:(CGFloat)ps paragraphSpaceBefore:(CGFloat)psb;

- (TextContainerView *)generatedTextViewWithFrame:(CGRect)frame;


@end
