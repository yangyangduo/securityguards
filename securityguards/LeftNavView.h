//
//  LeftNavView.h
//  funding
//
//  Created by Zhao yang on 12/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftNavItem.h"
#import "UIColor+MoreColor.h"

@protocol LeftNavViewDelegate <NSObject>

- (void)leftNavViewItemChanged:(LeftNavItem *)item;

@end

@interface LeftNavView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<LeftNavViewDelegate> delegate;
@property (nonatomic, strong) NSArray *navItems;
@property (nonatomic, strong) LeftNavItem *currentItem;

- (id)initWithFrame:(CGRect)frame andNavItems:(NSArray *)items;

- (void)setScreenName:(NSString *)screenName;
- (void)reset;

@end
