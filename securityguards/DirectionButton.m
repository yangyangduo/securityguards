//
//  DirectionButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DirectionButton.h"

@implementation DirectionButton {
    UIImageView *backgroundImageView;
    UIImageView *imgLeftButton;
    UIImageView *imgRightButton;
    UIImageView *imgTopButton;
    UIImageView *imgBottomButton;
    UIImageView *imgCenterButton;
    UITapGestureRecognizer *tapGesture;
    CGFloat centerRound;
    CGFloat outRound;
    NSString *btnType;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        btnType = type;
        if([@"tv" isEqualToString:type]) {
            [self initTVTypeUI];
        } else if([@"camera" isEqualToString:type]) {
            [self initCameraTypeUI];
        }else if ([@"bgMusic" isEqualToString:type]) {
            [self initTVTypeUI];
            imgCenterButton.image = [UIImage imageNamed:@"btn_play.png"];
        }
    }
    return self;
}

+ (DirectionButton *)cameraDirectionButtonWithPoint:(CGPoint)point {
    return [[DirectionButton alloc] initWithFrame:CGRectMake(point.x, point.y, 281/2, 282/2) andType:@"camera"];
}

+ (DirectionButton *)tvDirectionButtonWithPoint:(CGPoint)point {
    return [[DirectionButton alloc] initWithFrame:CGRectMake(point.x, point.y, 281/2, 282/2) andType:@"tv"];
}

+ (DirectionButton *)bgMusicDirectionButtonWithPoint:(CGPoint)point{
    return [[DirectionButton alloc] initWithFrame:CGRectMake(point.x, point.y, 281/2, 282/2) andType:@"bgMusic"];
}

- (void)initDefaults {
    
}

- (void)initTVTypeUI {
    CGPoint center = CGPointMake(70, 70.5);
    if(imgLeftButton == nil) {
        imgLeftButton = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 81/2, 182/2)];
        imgLeftButton.center = CGPointMake(imgLeftButton.center.x, center.y-1);
        imgLeftButton.image = [UIImage imageNamed:@"btn_rc_left.png"];
        [self addSubview:imgLeftButton];
    }
    
    if(imgRightButton == nil) {
        imgRightButton = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width- 81 / 2 - 6) , 0, 81/2, 182/2)];
        imgRightButton.center = CGPointMake(imgRightButton.center.x, center.y - 1);
        imgRightButton.image = [UIImage imageNamed:@"btn_rc_right.png"];
        [self addSubview:imgRightButton];
    }
    
    if(imgTopButton == nil) {
        imgTopButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 182/2, 81/2)];
        imgTopButton.center = CGPointMake(center.x - 1, imgTopButton.center.y);
        imgTopButton.image = [UIImage imageNamed:@"btn_rc_top.png"];
        [self addSubview:imgTopButton];
    }
    
    if(imgBottomButton == nil) {
        imgBottomButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 81 / 2 - 6), 182/2, 81/2)];
        imgBottomButton.center = CGPointMake(center.x - 1, imgBottomButton.center.y);
        imgBottomButton.image = [UIImage imageNamed:@"btn_rc_down.png"];
        [self addSubview:imgBottomButton];
    }
    
    if(imgCenterButton == nil) {
        imgCenterButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 126/2, 126/2)];
        imgCenterButton.center = CGPointMake(center.x - 1,center.y);
        imgCenterButton.image = [UIImage imageNamed:@"btn_rc_center.png"];
        [self addSubview:imgCenterButton];
    }
    
    if(tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }

}
- (void)initCameraTypeUI {
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"bg_camera.png"];
        [self addSubview:backgroundImageView];
    }
    
    if(imgLeftButton == nil) {
        imgLeftButton = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 81/2, 182/2)];
        imgLeftButton.center = CGPointMake(imgLeftButton.center.x, backgroundImageView.center.y-1);
        imgLeftButton.image = [UIImage imageNamed:@"btn_camera_left.png"];
        [self addSubview:imgLeftButton];
    }
    
    if(imgRightButton == nil) {
        imgRightButton = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width- 81 / 2 - 6) , 0, 81/2, 182/2)];
        imgRightButton.center = CGPointMake(imgRightButton.center.x, backgroundImageView.center.y - 1);
        imgRightButton.image = [UIImage imageNamed:@"btn_camera_right.png"];
        [self addSubview:imgRightButton];
    }
    
    if(imgTopButton == nil) {
        imgTopButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 182/2, 81/2)];
        imgTopButton.center = CGPointMake(backgroundImageView.center.x - 1, imgTopButton.center.y);
        imgTopButton.image = [UIImage imageNamed:@"btn_camera_top.png"];
        [self addSubview:imgTopButton];
    }
    
    if(imgBottomButton == nil) {
        imgBottomButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 81 / 2 - 6), 182/2, 81/2)];
        imgBottomButton.center = CGPointMake(backgroundImageView.center.x - 1, imgBottomButton.center.y);
        imgBottomButton.image = [UIImage imageNamed:@"btn_camera_bottom.png"];
        [self addSubview:imgBottomButton];
    }
    
    if(imgCenterButton == nil) {
        imgCenterButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 126/2, 126/2)];
        imgCenterButton.center = CGPointMake(backgroundImageView.center.x - 1, backgroundImageView.center.y - 1);
        imgCenterButton.image = [UIImage imageNamed:@"btn_camera_center.png"];
        [self addSubview:imgCenterButton];
    }
    
    if(tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    if(self.delegate == nil) return;
    
    CGPoint point = [gesture locationInView:self];
    CGFloat x = point.x,y=point.y;
    CGFloat x0 = x-71,y0=y-71;
    BOOL isCenter = x0 * x0 + y0 * y0 <= 31.5 * 31.5,
    outOfBounds = x0*x0 + y0*y0 >= 70.25*70.25,
    isTop = x0 / y0 > -1 && x0 / y0 < 1 && y0 < 0 && !isCenter,
    isLeft = (x0 / y0 > 1 || x0 / y0 < -1) && x0 < 0 && !isCenter,
    isBottom = (x0 / y0 > - 1 && x0 / y0 < 1) && y0 > 0 && !isCenter,
    isRight = (x0 / y0 > 1 || x0 / y0 < -1) && x0 > 0 && !isCenter;
    
    if(isCenter) {
        if([self.delegate respondsToSelector:@selector(centerButtonClicked)]) {
            [self.delegate centerButtonClicked];
            UIImage *centerImg = imgCenterButton.image;
            [UIView animateWithDuration:0.1f animations:^{
                imgCenterButton.image = [btnType isEqualToString:@"bgMusic"]?[UIImage imageNamed:@"btn_play_selected.png"]:[UIImage imageNamed:@"btn_rc_center_selected.png"];
                imgCenterButton.alpha = 0.5;
                
            } completion:^(BOOL finished){
                imgCenterButton.image =centerImg;
                imgCenterButton.alpha = 1;
            }];
        }
    } else if(isTop&&!outOfBounds) {
        if([self.delegate respondsToSelector:@selector(topButtonClicked)]) {
            [self.delegate topButtonClicked];
            UIImage *topImg = imgTopButton.image;
            [UIView animateWithDuration:0.1f animations:^{
                imgTopButton.image = [UIImage imageNamed:@"btn_rc_top_selected.png"];
                imgTopButton.alpha = 0.5;
            } completion:^(BOOL finished){
                imgTopButton.image = topImg;
                imgTopButton.alpha = 1;
            }];
        }
    } else if (isLeft&&!outOfBounds) {
        if([self.delegate respondsToSelector:@selector(leftButtonClicked)]) {
            [self.delegate leftButtonClicked];
            UIImage *leftImg = imgLeftButton.image;
            [UIView animateWithDuration:0.1f animations:^{
                imgLeftButton.image = [UIImage imageNamed:@"btn_rc_left_selected.png"];
                imgLeftButton.alpha = 0.5;
            } completion:^(BOOL finished){
                imgLeftButton.image = leftImg;
                imgLeftButton.alpha = 1;
            }];
        }
    } else if (isBottom&&!outOfBounds) {
        if([self.delegate respondsToSelector:@selector(bottomButtonClicked)]) {
            [self.delegate bottomButtonClicked];
            UIImage *bottomImg = imgBottomButton.image;
            [UIView animateWithDuration:0.1f animations:^{
                imgBottomButton.image = [UIImage imageNamed:@"btn_rc_down_selected.png"];
                imgBottomButton.alpha = 0.5;
            } completion:^(BOOL finished){
                imgBottomButton.image =bottomImg;
                imgBottomButton.alpha = 1;
            }];
        }
    } else if(isRight&&!outOfBounds) {
        if([self.delegate respondsToSelector:@selector(rightButtonClicked)]) {
            [self.delegate rightButtonClicked];
            UIImage *rightImg = imgRightButton.image;
            [UIView animateWithDuration:0.1f animations:^{
                imgRightButton.image = [UIImage imageNamed:@"btn_rc_right_selected.png"];
                imgRightButton.alpha = 0.5;
            } completion:^(BOOL finished){
                imgRightButton.image =rightImg;
                imgRightButton.alpha = 1;
            }];
        }
    } else {
        return;
    }
}

@end
