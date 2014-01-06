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

@property (nonatomic, weak) id<ImageProviderDelegate> delegate;
@property (atomic, assign) BOOL isDownloading;

- (void)startDownloader:(NSString *)url imageIndex:(unsigned int)index;
- (void)stopDownload;

@end
