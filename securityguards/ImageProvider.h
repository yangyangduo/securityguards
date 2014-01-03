//
//  ImageProvider.h
//  SmartHome
//
//  Created by Zhao yang on 9/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageProviderDelegate <NSObject>

- (void)imageProviderNotifyImageAvailable:(UIImage *)image;
- (void)imageProviderNotifyImageStreamWasEnded;

@optional

- (void)imageProviderNotifyReadingImageError;

@end

@interface ImageProvider : NSObject

@property (weak, nonatomic) id<ImageProviderDelegate> delegate;
@property (assign, atomic) BOOL isDownloading;

- (void)startDownloader:(NSString *)url imageIndex:(NSInteger)index;
- (void)stopDownload;

@end
