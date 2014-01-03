//
//  DirectionButton.h
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectionButtonDelegate <NSObject>

- (void)leftButtonClicked;
- (void)rightButtonClicked;
- (void)centerButtonClicked;
- (void)topButtonClicked;
- (void)bottomButtonClicked;

@end

@interface DirectionButton : UIView

@property (weak, nonatomic) id<DirectionButtonDelegate> delegate;

+ (DirectionButton *)cameraDirectionButtonWithPoint:(CGPoint)point;
+ (DirectionButton *)tvDirectionButtonWithPoint:(CGPoint)point;
+ (DirectionButton *)bgMusicDirectionButtonWithPoint:(CGPoint)point;

@end
