//
//  CameraLoadingView.m
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraLoadingView.h"
#import "XXStringUtils.h"

@implementation CameraLoadingView {
    UIActivityIndicatorView *indicatorView;
    UIButton *btnPlay;
    UILabel *lblTitle;
}

@synthesize delegate;
@synthesize cameraState = _cameraState_;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, 170, 110)];
    if(self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    
    btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 136 / 2, 136 / 2)];
    btnPlay.center = CGPointMake(self.bounds.size.width / 2, btnPlay.center.y);
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"btn_play_selected"] forState:UIControlStateHighlighted];
    [btnPlay addTarget:self action:@selector(btnPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPlay];

    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 3, 136 / 2, 136 / 2)];
    indicatorView.center = CGPointMake(self.bounds.size.width / 2, indicatorView.center.y);
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:indicatorView];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, btnPlay.frame.origin.y + btnPlay.bounds.size.height + 5, 160, 30)];
    lblTitle.textColor = [UIColor lightTextColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:lblTitle];
}

- (void)setCameraState:(CameraState)cameraState {
    _cameraState_ = cameraState;
    if(_cameraState_ == CameraStateNotOpen) {
        btnPlay.hidden = NO;
        if(indicatorView.isAnimating) {
            [indicatorView stopAnimating];
        }
        indicatorView.hidden = YES;
        lblTitle.text = NSLocalizedString(@"play", @"");
        lblTitle.hidden = NO;
    } else if(_cameraState_ == CameraStateOpenning) {
        btnPlay.hidden = YES;
        if(!indicatorView.isAnimating) {
            [indicatorView startAnimating];
        }
        indicatorView.hidden = NO;
        lblTitle.text = NSLocalizedString(@"camera_connectting", @"");
        lblTitle.hidden = NO;
    } else if(_cameraState_ == CameraStatePlaying) {
        btnPlay.hidden = YES;
        if(indicatorView.isAnimating) {
            [indicatorView stopAnimating];
        }
        lblTitle.text = [XXStringUtils emptyString];
        indicatorView.hidden = YES;
        lblTitle.hidden = YES;
    } else if(_cameraState_ == CameraStateError) {
        btnPlay.hidden = NO;
        if(indicatorView.isAnimating) {
            [indicatorView stopAnimating];
        }
        lblTitle.text = NSLocalizedString(@"camera_error", @"");
        indicatorView.hidden = YES;
        lblTitle.hidden = NO;
    }
}

- (void)btnPlayPressed:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(playButtonPressed)]) {
        [self.delegate playButtonPressed];
    }
}

@end
