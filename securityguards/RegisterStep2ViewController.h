//
//  RegisterStep2ViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@interface RegisterStep2ViewController : NavigationViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, assign) int countDown;

@end
