//
//  AccountManageCell.h
//  securityguards
//
//  Created by hadoop user account on 9/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManageCellData.h"
#define CELL_HEIGHT                 93/2
#define CELL_WIDTH                  624/2

@interface AccountManageCell : UITableViewCell
@property (nonatomic, strong) AccountManageCellData *data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(AccountManageCellData *) cellData;

- (void)loadData;
@end
