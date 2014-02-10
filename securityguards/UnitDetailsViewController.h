//
//  UnitDetailsViewController.h
//  securityguards
//
//  Created by Zhao yang on 2/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NavigationViewController.h"
#import "UnitRenameViewController.h"

@interface UnitDetailsViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate, TextViewDelegate>

@property (nonatomic, strong) Unit *unit;

- (instancetype)initWithUnit:(Unit *)unit;

@end
