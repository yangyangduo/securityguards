//
//  CameraLoadingView.h
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CameraState) {
    CameraStateNotOpen,
    CameraStateOpenning,
    CameraStatePlaying,
    CameraStateError
};

@protocol CameraLoadingViewDelegate <NSObject>

- (void)playButtonPressed;

@end

@interface CameraLoadingView : UIView

@property (nonatomic, assign) CameraState cameraState;
@property (nonatomic, weak) id<CameraLoadingViewDelegate> delegate;

- (id)initWithPoint:(CGPoint)point;

@end
