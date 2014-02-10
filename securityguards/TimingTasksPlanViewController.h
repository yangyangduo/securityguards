//
//  TimingTasksPlanViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "TimingTasksCell.h"

@interface TimingTasksPlanViewController : DrawerViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, TimingTaskCellDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

- (instancetype)initWithUnit:(Unit *)unit;

@property (nonatomic, strong) Unit *unit;

@property (nonatomic) BOOL needRefresh;

@end
