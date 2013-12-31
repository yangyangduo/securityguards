//
//  UnitSelectionDrawerView.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface UnitSelectionDrawerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) RootViewController *weakRootViewController;

- (void)refresh;

@end
