//
//  CameraViewController.h
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "XXEventSubscriber.h"
#import "DirectionButton.h"
#import "CameraSocket.h"

@interface CameraViewController : NavigationViewController<DirectionButtonDelegate, CameraMessageDelegate, XXEventSubscriber>

@property (strong, nonatomic) Device *cameraDevice;

@end
