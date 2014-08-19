//
//  PlayCameraPicViewController.h
//  securityguards
//
//  Created by hadoop user account on 2/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationData.h"
#import "NavigationViewController.h"
#import "ImageProvider.h"
#import "CameraLoadingView.h"

@interface PlayCameraPicViewController : NavigationViewController<ImageProviderDelegate, CameraLoadingViewDelegate>

@property (strong, nonatomic) NotificationData *data;

@end
