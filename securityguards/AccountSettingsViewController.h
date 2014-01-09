//
//  AccountSettingsViewController.h
//  SmartHome
//
//  Created by hadoop user account on 2/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"
#import "TextViewController.h"
#import "PasswordTextViewController.h"

@interface AccountSettingsViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, TextViewDelegate, XXEventSubscriber>

- (void)refresh;

@end
