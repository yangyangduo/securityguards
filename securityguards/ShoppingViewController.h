//
//  ShoppingViewController.h
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerViewController.h"
#import "MerchandiseDetailSelectView.h"

@interface ShoppingViewController : DrawerViewController<UITableViewDataSource, UITableViewDelegate, MerchandiseDetailSelectViewDelegate>

@end
