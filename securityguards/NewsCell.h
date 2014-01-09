//
//  NewsCell.h
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsCell : UITableViewCell

- (void)setContent:(NSString *)content;
- (void)setCreateTime:(NSString *)createTime;

@end
