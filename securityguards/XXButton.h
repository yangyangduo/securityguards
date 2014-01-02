//
//  XXButton.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterAware.h"
#define BLUE_BUTTON_DEFAULT_WIDTH 200
#define BLUE_BUTTON_DEFAULT_HEIGHT 53
@protocol LongPressDelegate;

@interface XXButton : UIButton<ParameterAware>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) id userObject;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (weak, nonatomic) id<LongPressDelegate> longPressDelegate;
+ (UIButton *)blueButtonWithPoint:(CGPoint) aPoint resize:(CGSize) aSize;
@end
@protocol LongPressDelegate <NSObject>

- (void)smButtonLongPressed:(XXButton *)button;

@end


