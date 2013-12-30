//
//  TextContainerView.m
//  SpeechRecognition
//
//  Created by young on 6/27/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "TextContainerView.h"

@implementation TextContainerView

@synthesize ctFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //some code here
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(self.ctFrame, context);
}

@end