//
// Created by Zhao yang on 4/8/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "SceneVoiceView.h"
#import "SceneButton.h"
#import "UIColor+MoreColor.h"
#import "SpeechViewController.h"
#import "Shared.h"
#import "ScenesTemplate.h"
#import "UnitManager.h"

@implementation SceneVoiceView {
}

- (instancetype)initWithPoint:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, SCENE_VOICE_VIEW_HEIGHT)];
    if(self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appWhite];

    SceneButton *btnSceneReturnHome =
            [[SceneButton alloc]
                    initWithFrame:CGRectMake(0, 0, 160, SCENE_VOICE_VIEW_HEIGHT / 2) iconImage:[UIImage imageNamed:@"btn_return_home"] iconOnleft:YES title:NSLocalizedString(@"scene_return_home", @"")];
    btnSceneReturnHome.tag = 1;
    [btnSceneReturnHome addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSceneReturnHome];

    SceneButton *btnSceneSleep = [[SceneButton alloc]
            initWithFrame:CGRectMake(160, 0, 160, SCENE_VOICE_VIEW_HEIGHT / 2) iconImage:[UIImage imageNamed:@"btn_sleep"] iconOnleft:NO title:NSLocalizedString(@"scene_sleep", @"")];
    btnSceneSleep.backgroundColor = [UIColor appGray];
    btnSceneSleep.tag = 2;
    [btnSceneSleep addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSceneSleep];

    SceneButton *btnSceneGetUp = [[SceneButton alloc]
            initWithFrame:CGRectMake(0, SCENE_VOICE_VIEW_HEIGHT / 2, 160, SCENE_VOICE_VIEW_HEIGHT / 2) iconImage:[UIImage imageNamed:@"btn_get_up"] iconOnleft:YES title:NSLocalizedString(@"scene_get_up", @"")];
    btnSceneGetUp.backgroundColor = [UIColor appGray];
    btnSceneGetUp.tag = 3;
    [btnSceneGetUp addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSceneGetUp];

    SceneButton *btnSceneOut = [[SceneButton alloc]
            initWithFrame:CGRectMake(160, SCENE_VOICE_VIEW_HEIGHT / 2, 160, SCENE_VOICE_VIEW_HEIGHT / 2) iconImage:[UIImage imageNamed:@"btn_out"] iconOnleft:NO title:NSLocalizedString(@"scene_out", @"")];
    btnSceneOut.tag = 4;
    [btnSceneOut addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSceneOut];

    UIButton *btnVoice = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 204 / 2, 204 / 2)];
    btnVoice.center = CGPointMake(self.bounds.size.width / 2.f, SCENE_VOICE_VIEW_HEIGHT / 2.f);
    btnVoice.tag = 5;
    [btnVoice addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_new_highlighted"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_new"] forState:UIControlStateHighlighted];
    [self addSubview:btnVoice];
}

- (void)btnPressed:(UIButton *)sender {
    if(1 == sender.tag) {
        [ScenesTemplate executeDefaultTemplatesWithTemplateId:kSceneReturnHome forUnit:[UnitManager defaultManager].currentUnit];
    } else if(2 == sender.tag) {
        [ScenesTemplate executeDefaultTemplatesWithTemplateId:kSceneSleep forUnit:[UnitManager defaultManager].currentUnit];
    } else if(3 == sender.tag) {
        [ScenesTemplate executeDefaultTemplatesWithTemplateId:kSceneGetUp forUnit:[UnitManager defaultManager].currentUnit];
    } else if(4 == sender.tag) {
        [ScenesTemplate executeDefaultTemplatesWithTemplateId:kSceneOut forUnit:[UnitManager defaultManager].currentUnit];
    } else if(5 == sender.tag) {
        UIViewController *topViewController = [Shared shared].app.topViewController.navigationController;
        if(topViewController != nil) {
            [topViewController presentViewController:[[SpeechViewController alloc] init] animated:YES completion:^{}];
        }
    }
}

@end