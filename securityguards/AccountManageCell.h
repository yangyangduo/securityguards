//
//  AccountManageCell.h
//  securityguards
//
//  Created by hadoop user account on 9/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManageCellData.h"

#define CELL_HEIGHT                 45
#define CELL_WIDTH                  300
#define CUSTOM_VIEW_TAG             1889

@interface AccountManageCell : UITableViewCell

@property (nonatomic, strong) AccountManageCellData *data;

- (void)loadData:(AccountManageCellData *) cellData;

@end
