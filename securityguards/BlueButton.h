//
//  BlueButton.h
//  securityguards
//
//  Created by Zhao yang on 1/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "XXButton.h"

#define BLUE_BUTTON_DEFAULT_WIDTH 200
#define BLUE_BUTTON_DEFAULT_HEIGHT 53

@interface BlueButton : XXButton

+ (BlueButton *)blueButtonWithPoint:(CGPoint)aPoint resize:(CGSize)aSize;

@end
