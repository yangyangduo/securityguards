//
//  PlayCameraPicViewController.m
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PlayCameraPicViewController.h"
#import "CameraPicPath.h"
#import "CameraLoadingView.h"
#import "LongButton.h"

#define FIRST_BUTTON_TAG 2000

@interface PlayCameraPicViewController ()

@end

@implementation PlayCameraPicViewController {
    BOOL isPlaying;
    IBOutlet UIImageView *playView;
    ImageProvider *provider;
    BOOL isFirst;
    CameraLoadingView *loadingView;
}

@synthesize data;

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

- (void)initDefaults {
    provider = [[ImageProvider alloc] init];
    provider.delegate = self;
    isPlaying = NO;
    isFirst = YES;
}

- (void)initUI {
    [super initUI];
    
    if(playView == nil) {
        playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, 320, 240)];
        playView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:playView];
        
        if(loadingView == nil) {
            loadingView = [CameraLoadingView viewWithPoint:CGPointMake(0, 0)];
            loadingView.center = CGPointMake(playView.center.x, playView.bounds.size.height / 2);
            [loadingView hide];
            [playView addSubview:loadingView];
        }
    }
        
    if(data.cameraPicPaths != nil) {
        for (int i = 0; i<data.cameraPicPaths.count; i++) {
            LongButton *btnPlayCamera = [LongButton buttonWithPoint:CGPointMake(5, self.topbar.bounds.size.height + i * 54 + 245)];
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
    
    self.topbar.titleLabel.text = NSLocalizedString(@"view_message_video", @"");
}

- (void)viewDidAppear:(BOOL)animated {
    LongButton *firstButton = (LongButton *)[self.view viewWithTag:FIRST_BUTTON_TAG];
    if(firstButton != nil) {
        [self play:firstButton];
    }
}

- (void)dismiss {
    if(provider != nil) {
        [provider stopDownload];
    }
    [super dismiss];
}

- (void)play:(id<ParameterExtentions>)source {
    if(isPlaying) {
        if(provider != nil && provider.isDownloading) {
            [provider stopDownload];
        }
        return;
    }
    
    if(source != nil) {
        NSString *url = [source parameterForKey:@"url"];
        if(![NSString isBlank:url]) {
            isPlaying = YES;
            [loadingView show];
            [self performSelectorInBackground:@selector(startDownloader:) withObject:url];
        }
    }
}

- (void)startDownloader:(NSString *)url {
    [provider startDownloader:url imageIndex:0];
}

#pragma mark -
#pragma mark Image Provider Delegate

- (void)imageProviderNotifyImageAvailable:(UIImage *)image {
    if(isFirst) {
        isFirst = NO;
        [loadingView hide];
    }
    playView.image = image;
}

- (void)imageProviderNotifyImageStreamWasEnded {
    isPlaying = NO;
    isFirst = YES;
    playView.image = nil;
    [loadingView showError];
#ifdef DEBUG
    NSLog(@"[Image provider] Download Ended.");
#endif
}

- (void)imageProviderNotifyReadingImageError {
    isPlaying = NO;
    isFirst = YES;
    playView.image = nil;
    [loadingView showError];
#ifdef DEBUG
    NSLog(@"[Image provider] Reading Error.");
#endif
}

@end
