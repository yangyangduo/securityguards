//
//  ImageProvider.m
//  SmartHome
//
//  Created by Zhao yang on 9/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ImageProvider.h"

#define IMAGE_PLAY_INTERVAL       300
#define MAX_DOWNLOAD_ERROR_COUNT  3

@implementation ImageProvider {
    long long lastedDownloadingTime;
    NSUInteger errorCount;
}

@synthesize delegate;
@synthesize isDownloading;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    lastedDownloadingTime = -1;
    errorCount = 0;
}

- (void)startDownloader:(NSString *)url imageIndex:(unsigned int)index {
    if(self.isDownloading) {
        return;
    } else {
        self.isDownloading = YES;
        errorCount = 0;
        [self startDownloaderInternal:url imageIndex:index];
    }
}

- (void)stopDownload {
    self.isDownloading = NO;
}

- (void)startDownloaderInternal:(NSString *)url imageIndex:(unsigned int)index {
    if(!self.isDownloading) {
        [self performSelectorOnMainThread:@selector(notifyImageStreamWasEnded) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSURL *_url_ = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%d.jpg", url, index]];
    
    // prepare
    NSError *error;
    NSURLResponse *response;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_url_ cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    // send request
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // process response
    if(error == nil && response != nil && data != nil) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if(resp.statusCode == 200) {
            errorCount = 0;
            UIImage *image = [UIImage imageWithData:data];
            if(image != nil) {
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
                if(!self.isDownloading) {
                    [self performSelectorOnMainThread:@selector(notifyImageStreamWasEnded) withObject:nil waitUntilDone:NO];
                } else {
                    [self performSelectorOnMainThread:@selector(notityImageWasAvailable:) withObject:image waitUntilDone:YES];
                    index++;
                    [self startDownloaderInternal:url imageIndex:index];
                }
            }
        } else {
            if(resp.statusCode == 404) {
                errorCount++;
                if(errorCount <= MAX_DOWNLOAD_ERROR_COUNT && self.isDownloading) {
                    index++;
                    [self startDownloaderInternal:url imageIndex:index];
                } else {
                    self.isDownloading = NO;
                    [self performSelectorOnMainThread:@selector(notifyImageStreamWasEnded) withObject:nil waitUntilDone:NO];
                }
            } else {
                self.isDownloading = NO;
                [self performSelectorOnMainThread:@selector(notifyImageReadingError) withObject:nil waitUntilDone:NO];
            }
        }
    } else {
        self.isDownloading = NO;
        [self performSelectorOnMainThread:@selector(notifyImageReadingError) withObject:nil waitUntilDone:NO];
    }
}

- (void)notityImageWasAvailable:(UIImage *)image {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imageProviderNotifyImageAvailable:)]) {
        [self.delegate imageProviderNotifyImageAvailable:image];
    }
}

- (void)notifyImageStreamWasEnded {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imageProviderNotifyImageStreamWasEnded)]) {
        [self.delegate imageProviderNotifyImageStreamWasEnded];
    }
}

- (void)notifyImageReadingError {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imageProviderNotifyReadingImageError)]) {
        [self.delegate imageProviderNotifyReadingImageError];
    }
}

@end
