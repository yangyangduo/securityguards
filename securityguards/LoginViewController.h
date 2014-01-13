//
//  LoginViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>

@property (assign,nonatomic) BOOL hasLogin;

@end
