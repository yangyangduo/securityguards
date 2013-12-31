//
//  PlayCameraPicViewController.h
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PopViewController.h"
#import "NotificationData.h"
#import "ImageProvider.h"

@interface PlayCameraPicViewController : PopViewController<ImageProviderDelegate>

@property (strong, nonatomic) NotificationData *data;

@end
