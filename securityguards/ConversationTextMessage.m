//
//  ConversationTextMessage.m
//  SmartHome
//
//  Created by Zhao yang on 8/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ConversationTextMessage.h"
#import "TextContainerView.h"
#import "ParagraphBuilder.h"
#import "AttributedStringBuilder.h"
#import "XXStringUtils.h"

#define DEFAULT_FONT @"Helvetica"
#define MESSAGE_MAX_WIDTH 250
#define BubbleSpace 10

@implementation ConversationTextMessage {
    UIView *messageView;
}

@synthesize textMessage;
@synthesize statusMessage;
@synthesize timeMessage;

- (UIView *)viewWithMessage:(CGFloat)tblConversationWidth {
    if(messageView != nil) return messageView;
    if([XXStringUtils isEmpty:self.textMessage]) return nil;
    
    //generated text view

    AttributedStringBuilder *stringBuilder = [[AttributedStringBuilder alloc] init];
    NSMutableAttributedString *str = [stringBuilder appendStringWithString:self.textMessage
            fontColor:[UIColor darkGrayColor] fontName:DEFAULT_FONT fontSize:15.f fontWidth:0.f fontSpace:0.f
            underLineStyle: UNDER_LINE_STYLE_NONE underLineColor:nil];
    
/*    [stringBuilder appendStringWithString:self.textMessage
            fontColor:[UIColor darkGrayColor] fontName:DEFAULT_FONT fontSize:15.f fontWidth:0.f fontSpace:0.f
            underLineStyle: UNDER_LINE_STYLE_NONE underLineColor:nil];*/
    
    if(![XXStringUtils isBlank:self.timeMessage]) {
        str = [stringBuilder appendStringWithString:[NSString stringWithFormat:@"\r\n%@", self.timeMessage]
            fontColor:[UIColor lightGrayColor] fontName:DEFAULT_FONT fontSize:12.f fontWidth:0.f fontSpace:0.f
            underLineStyle: UNDER_LINE_STYLE_NONE underLineColor:nil];
    }
    
    ParagraphBuilder *paragraph = [[ParagraphBuilder alloc] init];
    paragraph.autoFitHeight = YES;
    paragraph.autoFitWidth = YES;
    [paragraph addParagraphWithAttributedString:str lineSpace:2.f textAlign:TEXT_ALIGN_NATURAL
        lineBreakMode:LINE_BREAK_MODE_WORD_WRAPPING paragraphSpace:0.f paragraphSpaceBefore:0.f];
    
    TextContainerView *textView =
        [paragraph generatedTextViewWithFrame:
         CGRectMake(((self.messageOwner == MESSAGE_OWNER_THEIRS) ? 10 : 5), 5, MESSAGE_MAX_WIDTH, 0)];
    textView.backgroundColor = [UIColor clearColor];
    
    //wrapper text view

    UIImageView *backgroundImage = nil;
    if(self.messageOwner == MESSAGE_OWNER_THEIRS) {
        backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textView.frame.size.width + 16, textView.frame.size.height + 12)];
        backgroundImage.image = [[UIImage imageNamed:@"bubble_theirs.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:22];
    } else if(self.messageOwner == MESSAGE_OWNER_MINE) {
        backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textView.frame.size.width + 16, textView.frame.size.height + 12)];
        backgroundImage.image = [[UIImage imageNamed:@"bubble_mine.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:22];
    }

    messageView = [[UIView alloc] initWithFrame:
                   CGRectMake(((self.messageOwner == MESSAGE_OWNER_THEIRS) ? BubbleSpace : (tblConversationWidth - backgroundImage.frame.size.width - BubbleSpace)), 0, backgroundImage.frame.size.width, backgroundImage.frame.size.height)];
    messageView.backgroundColor = [UIColor clearColor];
    [messageView addSubview:backgroundImage];
    [messageView addSubview:textView];
    
    return messageView;
}

@end
