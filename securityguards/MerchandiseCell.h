//
//  MerchandiseCell.h
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchandise.h"

#define MerchandiseCellHeight 138

@interface MerchandiseCell : UITableViewCell

@property (nonatomic, strong) Merchandise *merchandise;

@end
