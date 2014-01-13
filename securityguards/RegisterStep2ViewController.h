//
//  RegisterStep2ViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@interface RegisterStep2ViewController : NavigationViewController<UITextFieldDelegate>

@property (strong,nonatomic) NSString *phoneNumber;
@property (assign,nonatomic) int countDown;
@property (assign, nonatomic, readonly) BOOL isModify;

- (id) initAsModify:(BOOL) modify;
@end
