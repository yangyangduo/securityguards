//
//  AttributedStringBuilder.h
//  SpeechRecognition
//
//  Created by young on 6/27/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef NS_ENUM(NSInteger, UNDER_LINE_STYLE) {
    UNDER_LINE_STYLE_NONE           = 0x00,
    UNDER_LINE_STYLE_Single         = 0x01,
    UNDER_LINE_STYLE_Thick          = 0x02,
    UNDER_LINE_STYLE_Double         = 0x09
};

@interface AttributedStringBuilder : NSObject

- (NSMutableAttributedString *)appendStringWithString:
        (NSString *)str fontColor:(UIColor *)fc fontName:(NSString *)fn
        fontSize:(CGFloat)fs fontWidth:(CGFloat)fw fontSpace:(long)fsp
        underLineStyle:(UNDER_LINE_STYLE)uls underLineColor:(UIColor *)ulc;

@end
