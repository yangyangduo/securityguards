//
//  CameraLoadingView.h
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraLoadingView : UIView

+ (CameraLoadingView *)viewWithPoint:(CGPoint)point;

@property (strong, nonatomic) NSString *message;

- (void)show;
- (void)hide;
- (void)showError;

@end
