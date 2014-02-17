//
//  ShoppingViewController.h
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerViewController.h"
#import "MerchandiseDetailSelectView.h"
#import "EGORefreshTableHeaderView.h"

@interface ShoppingViewController : DrawerViewController<UITableViewDataSource, UITableViewDelegate, MerchandiseDetailSelectViewDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
}

@end
