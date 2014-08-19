//
//  PlayCameraPicViewController.m
//  securityguards
//
//  Created by hadoop user account on 2/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PlayCameraPicViewController.h"
#import "BlueButton.h"
#import "CameraPicPath.h"
#import "XXParameterAware.h"

#define FIRST_BUTTON_TAG 2000

@interface PlayCameraPicViewController ()

@end

@implementation PlayCameraPicViewController{
    BOOL isPlaying;
    IBOutlet UIImageView *playView;
    ImageProvider *provider;
    BOOL isFirst;
    CameraLoadingView *loadingView;
}
@synthesize data;

- (void)initDefaults {
    provider = [[ImageProvider alloc] init];
    provider.delegate = self;
    isPlaying = NO;
    isFirst = YES;
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = @"查看报警视频";
    
    playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240)];
    playView.backgroundColor = [UIColor blackColor];
    playView.userInteractionEnabled = YES;
    [self.view addSubview:playView];

    loadingView = [[CameraLoadingView alloc] initWithPoint:CGPointMake(0, 0)];
    loadingView.center = CGPointMake(playView.center.x, playView.bounds.size.height / 2);
    loadingView.cameraState = CameraStateNotOpen;
    loadingView.delegate = self;
    [playView addSubview:loadingView];
    
    if(data.cameraPicPaths != nil) {
        for (int i = 0; i<data.cameraPicPaths.count; i++) {
            BlueButton *btnPlayCamera = [BlueButton blueButtonWithPoint:CGPointMake(5, self.topbarView.bounds.size.height + i * 54 + 245) resize:CGSizeMake(311, BLUE_BUTTON_DEFAULT_HEIGHT)];//[LongButton buttonWithPoint:CGPointMake(5, self.topbar.bounds.size.height + i * 54 + 245)];
            CameraPicPath *path = [data.cameraPicPaths objectAtIndex:i];
            if (i == 0) {
                btnPlayCamera.tag = FIRST_BUTTON_TAG;
            }
            NSString *url = [NSString stringWithFormat:@"%@%@", data.http, path.path];
            [btnPlayCamera setParameter:url forKey:@"url"];
            [btnPlayCamera setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"play", @""), path.name] forState:UIControlStateNormal];
            [btnPlayCamera addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnPlayCamera];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self playFirstCamera];
}

- (void)popupViewController {
    if(provider != nil) {
        [provider stopDownload];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)play:(id<XXParameterAware>)source {
    if(isPlaying) {
        if(provider != nil && provider.isDownloading) {
            [provider stopDownload];
        }
        return;
    }
    
    if(source != nil) {
        NSString *url = [source parameterForKey:@"url"];
        if(![XXStringUtils isBlank:url]) {
            isPlaying = YES;
            loadingView.cameraState = CameraStateOpenning;
            [self performSelectorInBackground:@selector(startDownloader:) withObject:url];
        }
    }
}

- (void)startDownloader:(NSString *)url {
    [provider startDownloader:url imageIndex:0];
}

- (void)playFirstCamera {
    XXButton *firstButton = (XXButton *)[self.view viewWithTag:FIRST_BUTTON_TAG];
    if(firstButton != nil) {
        [self play:firstButton];
    }
}

#pragma mark -
#pragma mark Image Provider Delegate

- (void)imageProviderNotifyImageAvailable:(UIImage *)image {
    if(isFirst) {
        isFirst = NO;
        loadingView.cameraState = CameraStatePlaying;
    }
    playView.image = image;
}

- (void)imageProviderNotifyImageStreamWasEnded {
    isPlaying = NO;
    isFirst = YES;
    playView.image = nil;
    loadingView.cameraState = CameraStateNotOpen;
#ifdef DEBUG
    NSLog(@"[Image provider] Download Ended.");
#endif
}

- (void)imageProviderNotifyReadingImageError {
    isPlaying = NO;
    isFirst = YES;
    playView.image = nil;
    loadingView.cameraState = CameraStateError;
#ifdef DEBUG
    NSLog(@"[Image provider] Reading Error.");
#endif
}

- (void)playButtonPressed {
    [self playFirstCamera];
}

@end
