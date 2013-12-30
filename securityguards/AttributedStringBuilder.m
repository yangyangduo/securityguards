//
//  AttributedStringBuilder.m
//  SpeechRecognition
//
//  Created by young on 6/27/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "AttributedStringBuilder.h"

@implementation AttributedStringBuilder {
    NSMutableAttributedString *string;
}

- (id)init {
    self = [super init];
    if(self) {
        string = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

/*
 * str
 * font color
 * font name
 * font size
 * font width
 * font space
 * under line style
 * under line color
 *
 */
- (NSMutableAttributedString *)appendStringWithString:
        (NSString *)str fontColor:(UIColor *)fc fontName:(NSString *)fn
         fontSize:(CGFloat)fs fontWidth:(CGFloat)fw fontSpace:(long)fsp
         underLineStyle:(UNDER_LINE_STYLE)uls underLineColor:(UIColor *)ulc {
    
    if(str == nil || [@"" isEqualToString:str]) {
        return string;
    }
    
    if(fn == nil || [@"" isEqualToString:fn]) {
        fn = [UIFont systemFontOfSize:12.f].fontName;
    }
    
    if(uls != UNDER_LINE_STYLE_NONE && ulc == nil) {
        ulc = [UIColor blackColor];
    }
    
    if(fc == nil) {
        fc = [UIColor blackColor];
    }
    
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fn, fs, NULL);
    CFNumberRef fontSpace = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &fsp);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 (id)fc.CGColor, kCTForegroundColorAttributeName,
                                 (__bridge id)font, kCTFontAttributeName,
                                 (id)[NSNumber numberWithFloat: fw], kCTStrokeWidthAttributeName,
                                 (id)[UIColor whiteColor].CGColor, kCTStrokeColorAttributeName,
                                 (__bridge id)fontSpace, kCTKernAttributeName,
                                 (id)[NSNumber numberWithInt:uls], kCTUnderlineStyleAttributeName,
                                 (id)ulc.CGColor, kCTUnderlineColorAttributeName,
                                 nil];
    
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:attr]];
    return string;
}


@end
