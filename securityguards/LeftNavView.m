//
//  LeftNavView.m
//  funding
//
//  Created by Zhao yang on 12/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LeftNavView.h"
#import "Shared.h"
#import "UIDevice+SystemVersion.h"

@implementation LeftNavView {
    UITableView *tblItems;
}

@synthesize delegate;
@synthesize navItems = _navItems_;
@synthesize currentItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNavItems:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        self.navItems = items;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor appGray];
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(32, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 34 : 14, 284 / 3, 94 / 3)];
    imgLogo.image = [UIImage imageNamed:@"logo_left_drawer"];
    [self addSubview:imgLogo];
    
    tblItems = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.bounds.size.width, self.bounds.size.height - 120) style:UITableViewStylePlain];
    tblItems.backgroundColor = [UIColor appBlue];
    tblItems.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblItems.bounces = NO;
    tblItems.delegate = self;
    tblItems.dataSource = self;
    [self addSubview:tblItems];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.navItems == nil ? 0 : self.navItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appLightBlue];
    }
    
    LeftNavItem *item = [self.navItems objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:item.imageName];
    cell.textLabel.text = item.displayName;
    
    if(indexPath.row == 0) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftNavItem *item = nil;
    LeftNavItem *selectedItem = [self.navItems objectAtIndex:indexPath.row];
    if([@"logoutItem" isEqualToString:selectedItem.identifier]) {
        [[Shared shared].app logout];
        return;
    } else {
        if(![currentItem.identifier isEqualToString:selectedItem.identifier]) {
            currentItem = selectedItem;
            item = currentItem;
        }
    }
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(leftNavViewItemChanged:)]) {
        [self.delegate leftNavViewItemChanged:item];
    }
}

- (void)setNavItems:(NSArray *)navItems {
    _navItems_ = navItems;
    if(_navItems_ == nil || _navItems_.count == 0) {
        self.currentItem = nil;
    } else {
        self.currentItem = [_navItems_ objectAtIndex:0];
    }
}

- (void)reset {
    if(self.navItems == nil || self.navItems.count == 0) {
        self.currentItem = nil;
    } else {
        self.currentItem = [self.navItems objectAtIndex:0];
    }
    [tblItems reloadData];
}

@end
