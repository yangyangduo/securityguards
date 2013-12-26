//
//  CameraService.m
//  SmartHome
//
//  Created by Zhao yang on 10/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraService.h"

#define IMAGE_PLAY_INTERVAL 300

@implementation CameraService {
    BOOL playing;
    BOOL notify;
    long long lastedDownloadingTime;
}

@synthesize delegate;
@synthesize url = _url_;

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if(self) {
        [super setupWithUrl:[XXStringUtils emptyString]];
        self.client.timeoutInterval = 3;
        _url_ = url;
        playing = NO;
        notify = YES;
        lastedDownloadingTime = -1;
    }
    return self;
}

- (void)loadingImageInternal {
    [self.client get:_url_ acceptType:@"image/*"
        success:^(RestResponse *resp) {
            if(resp.statusCode == 200 && resp.body != nil) {
                UIImage *image = [UIImage imageWithData:resp.body];
                if(playing && image != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyNewImageWasReceived:)]) {
                    if(lastedDownloadingTime == -1) {
                        lastedDownloadingTime = [NSDate date].timeIntervalSince1970 * 1000;
                    } else {
                        NSTimeInterval now = [NSDate date].timeIntervalSince1970;
                        long long timeDifference = now * 1000 - lastedDownloadingTime;
                        if(timeDifference < IMAGE_PLAY_INTERVAL) {
                            [NSThread sleepForTimeInterval:((double)(IMAGE_PLAY_INTERVAL - timeDifference)) / 1000];
                            lastedDownloadingTime =[NSDate date].timeIntervalSince1970 * 1000;
                        } else {
                            lastedDownloadingTime = [NSDate date].timeIntervalSince1970 * 1000;
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate notifyNewImageWasReceived:image];
                    });
                    [self loadingImageInBackground];
                    return;
                }
            }
            if(playing) {
                [self doError:resp.statusCode];
                return;
            }
        }
        error:^(RestResponse *resp){
            [self doError:resp.statusCode];
            return;
        }];
}

- (void)doError:(NSUInteger)statusCode {
#ifdef DEBUG
    NSLog(@"[CAMERA RESTFUL SERVICE] Error in reading image, status code is %d", statusCode);
#endif
    [self close];
}

- (void)loadingImageInBackground {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadingImageInternal];
    });
}

- (void)open {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyCameraConnectted)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate notifyCameraConnectted];
        });
    }
    if(self.delegate != nil) {
        playing = YES;
        lastedDownloadingTime = -1;
        [self loadingImageInBackground];
#ifdef DEBUG
        NSLog(@"[CAMERA RESTFUL SERVICE] Opened");
#endif
    }
}

- (BOOL)isPlaying {
    return playing;
}

- (void)close {
    playing = NO;
    lastedDownloadingTime = -1;
    
    if(notify) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyCameraWasDisconnectted)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate notifyCameraWasDisconnectted];
            });
        }
    }
    
#ifdef DEBUG
    NSLog(@"[CAMERA RESTFUL SERVICE] Closed");
#endif
}

- (void)dontNotifyMe {
    notify = NO;
}

@end
