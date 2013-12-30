//
//  TextContainerView.h
//  SpeechRecognition
//
//  Created by young on 6/27/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface TextContainerView : UIScrollView

@property(assign, nonatomic) CTFrameRef ctFrame;

@end
