//
//  CameraInfoModifyViewController.h
//  securityguards
//
//  Created by Zhao yang on 2/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"
#import "TextViewController.h"

@interface CameraInfoModifyViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate, TextViewDelegate>

@property (nonatomic, strong) Device *cameraDevice;

- (instancetype)initWithCameraDevice:(Device *)cameraDevice;

@end
