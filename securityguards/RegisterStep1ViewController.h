//
//  RegisterStep1ViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@interface RegisterStep1ViewController : NavigationViewController<UITextFieldDelegate>
@property (assign, nonatomic, readonly) BOOL isModify;
- (id)initAsModify:(BOOL) modify;

@end
