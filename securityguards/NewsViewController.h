
//
//  NewsViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DrawerViewController.h"
#import "PullTableView.h"

@interface NewsViewController : DrawerViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@end
