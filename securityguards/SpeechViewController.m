//
//  SpeechViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechViewController.h"
#import "RootViewController.h"

@interface SpeechViewController ()

@end

@implementation SpeechViewController {
    BOOL portalViewIsOpenning;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    RootViewController *rootViewController = (RootViewController *)self.parentViewController;
    [rootViewController disableGestureForDrawerView];
}

- (void)viewWillDisappear:(BOOL)animated {
    RootViewController *rootViewController = (RootViewController *)self.parentViewController;
    [rootViewController enableGestureForDrawerView];
}

- (void)initDefaults {
    [super initDefaults];
    
    portalViewIsOpenning = NO;
}

- (void)initUI {
    [super initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topbarView.title = @"speech test";
    
    /*
     * Create voice button view
     */
    UIView *voiceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 42, [UIScreen mainScreen].bounds.size.width, 42)];
    voiceBackgroundView.backgroundColor = [UIColor appGray];
    
    UIButton *btnVoice = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 556 / 2, 64 / 2)];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_gray"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_blue"] forState:UIControlStateHighlighted];
    [btnVoice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnVoice setTitle:NSLocalizedString(@"press_begin_speaking", @"") forState:UIControlStateNormal];
    [btnVoice setTitle:NSLocalizedString(@"release_end_speaking", @"") forState:UIControlStateHighlighted];
    btnVoice.center = CGPointMake(voiceBackgroundView.center.x, btnVoice.center.y);
    
    /*
     
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
     
     */
    
    [voiceBackgroundView addSubview:btnVoice];
    [self.view addSubview:voiceBackgroundView];
}

- (void)popupViewController {
    if(portalViewIsOpenning) return;
    if(self.parentViewController != nil) {
        portalViewIsOpenning = YES;
        RootViewController *rootViewController = (RootViewController *)self.parentViewController;
        UIViewController *toViewController = rootViewController.portalViewController.parentViewController;
        [self willMoveToParentViewController:nil];
        [rootViewController addChildViewController:toViewController];
        [rootViewController transitionFromViewController:self toViewController:toViewController duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve
            animations:^{}
            completion:^(BOOL finished){
                [toViewController didMoveToParentViewController:rootViewController];
                [self removeFromParentViewController];
                [rootViewController setDisplayViewController:toViewController];
                portalViewIsOpenning = NO;
            }];
    }
}

@end
