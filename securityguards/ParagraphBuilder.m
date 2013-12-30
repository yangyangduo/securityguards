//
//  ParagraphBuilder.m
//  SpeechRecognition
//
//  Created by young on 6/27/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "ParagraphBuilder.h"

#define MAX_CALC_HEIGHT 2000.f

@implementation ParagraphBuilder {
    TextContainerView *textContainerView;
    NSMutableAttributedString *strings;
}

@synthesize autoFitWidth;
@synthesize autoFitHeight;

- (void)addParagraphWithAttributedString:
        (NSMutableAttributedString *)str lineSpace:(CGFloat)ls
        textAlign:(TEXT_ALIGN)ta /*firstLineIndent:(CGFloat)fli
headIndent:(CGFloat)hi*/ lineBreakMode:(LINE_BREAK_MODE)lbm
        paragraphSpace:(CGFloat)ps paragraphSpaceBefore:(CGFloat)psb {
    
    //指定为对齐属性
    CTTextAlignment alignment = (CTTextAlignment)ta;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value =& alignment;
    
    //行间距
    CGFloat lineSpace = ls;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(24.f);
    lineSpaceStyle.value = &lineSpace;
    
    //首行缩进
    CGFloat fristLineIndent = 1;//28.0f;
    CTParagraphStyleSetting fristLineIndentStyle;
    fristLineIndentStyle.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristLineIndentStyle.value = &fristLineIndent;
    fristLineIndentStyle.valueSize = sizeof(float);
    
    //段缩进
    CGFloat headIndent = 1;//10.0f;
    CTParagraphStyleSetting headIndentStyle;
    headIndentStyle.spec = kCTParagraphStyleSpecifierHeadIndent;
    headIndentStyle.value = &headIndent;
    headIndentStyle.valueSize = sizeof(float);
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = (CTLineBreakMode)lbm;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    //段前间隔, 从第二段文字开始
    CGFloat paragraphSpace = ps;//25.0f;
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.value = &paragraphSpace;
    paragraphSpaceStyle.valueSize = sizeof(float);
    
    //段前间隔, 从第二段文字开始
    CGFloat paragraphSpaceBefore = psb;//25.0f;
    CTParagraphStyleSetting paragraphSpaceBeforeStyle;
    paragraphSpaceBeforeStyle.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    paragraphSpaceBeforeStyle.value = &paragraphSpaceBefore;
    paragraphSpaceBeforeStyle.valueSize = sizeof(float);
    
    CTParagraphStyleSetting settings[] = {
        alignmentStyle,
        lineSpaceStyle,
        fristLineIndentStyle,
        headIndentStyle,
        lineBreakMode,
        paragraphSpaceStyle,
//        paragraphSpaceBeforeStyle
    };
    
    CTParagraphStyleRef paragraph = CTParagraphStyleCreate(settings, sizeof(settings));
    [str addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)paragraph range:NSMakeRange(0, str.length)];
    
    if(strings == nil) {
        strings = [[NSMutableAttributedString alloc] init];
    }
    
    [strings appendAttributedString:str];
}

- (TextContainerView *)generatedTextViewWithFrame:(CGRect)frame {
    if(strings == nil) return nil;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, frame.size.width, MAX_CALC_HEIGHT));
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)strings);
    CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, strings.length), path, NULL);
    
    CGSize size = [self calcSizeForCTFrame:ctframe];
    
    //re-define path && ctframe
    CGPathRelease(path);
    CFRelease(ctframe);
    path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.autoFitWidth?size.width:frame.size.width, self.autoFitHeight?size.height:frame.size.height));
    ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, strings.length), path, NULL);
    
    TextContainerView *textView = [[TextContainerView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, self.autoFitWidth?size.width:frame.size.width, self.autoFitHeight?size.height:frame.size.height)];
    textView.ctFrame = ctframe;
    
    return textView;
}

/*
 关于lineWidth的计算
 对于指定的frist Line Indent Style的行需要加上这个宽度
 待解决
 */
- (CGSize)calcSizeForCTFrame:(CTFrameRef)f {
    CGPathRef path = CTFrameGetPath(f);
    CGRect rect = CGPathGetBoundingBox(path);
    
    CFArrayRef lines = CTFrameGetLines(f);
    CFIndex lineCounts = CFArrayGetCount(lines);
    
    CGFloat lineMaxWidth = 0.f;
    CGFloat textHeight = 0.f;
    
    for(CFIndex i=0; i<lineCounts; i++) {
        CGFloat ascent, descent, leading, lineWidth;
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        if(lineWidth > lineMaxWidth) {
            lineMaxWidth = lineWidth;
        }
        if(i == lineCounts -1) {
            CGPoint lastLineOrgin;
            CTFrameGetLineOrigins(f, CFRangeMake(i, 1), &lastLineOrgin);
            textHeight = CGRectGetMaxY(rect)-lastLineOrgin.y + descent;
        }
    }
    
    //why shoulb be plus one px
    //i think here is a bug for core text that i can't resolved  --- young
    lineMaxWidth += 1.f;

    return CGSizeMake(ceil(lineMaxWidth), ceil(textHeight));
}

@end
