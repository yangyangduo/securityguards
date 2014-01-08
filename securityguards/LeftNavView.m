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

#import "AccountSettingsViewController.h"
#import "Shared.h"

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
    
    UIButton *btnHeader = [[UIButton alloc] initWithFrame:CGRectMake(10, imgLogo.frame.origin.y + imgLogo.bounds.size.height + 20, 79.f / 2, 80 / 2)];
    [btnHeader setBackgroundImage:[UIImage imageNamed:@"icon_header"] forState:UIControlStateNormal];
    [btnHeader addTarget:self action:@selector(showAccountSettingsViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnHeader];
    
    UILabel *lblAccount = [[UILabel alloc] initWithFrame:CGRectMake(59, btnHeader.frame.origin.y - 4, 92, 21)];
    lblAccount.text = @"Young-hentre";
    lblAccount.textColor = [UIColor lightGrayColor];
    lblAccount.font = [UIFont systemFontOfSize:14.f];
    lblAccount.backgroundColor = [UIColor clearColor];
    [self addSubview:lblAccount];
    
    UILabel *lblAccountSetting = [[UILabel alloc] initWithFrame:CGRectMake(59, btnHeader.frame.origin.y + 23, 60, 21)];
    lblAccountSetting.text = NSLocalizedString(@"account_settings", @"");
    lblAccountSetting.textColor = [UIColor lightGrayColor];
    lblAccountSetting.font = [UIFont systemFontOfSize:12.f];
    lblAccountSetting.backgroundColor = [UIColor clearColor];
    [self addSubview:lblAccountSetting];
    
    CGFloat height = btnHeader.frame.origin.y + btnHeader.bounds.size.height + 20;
    tblItems = [[UITableView alloc] initWithFrame:CGRectMake(0, height, self.bounds.size.width, self.bounds.size.height - height) style:UITableViewStylePlain];
    tblItems.backgroundColor = [UIColor appBlue];
    tblItems.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblItems.bounces = NO;
    tblItems.delegate = self;
    tblItems.dataSource = self;
    [self addSubview:tblItems];
}

#pragma mark -
#pragma mark UI Methods

- (void)showAccountSettingsViewController:(id)sender {
    [[Shared shared].app.rootViewController.navigationController pushViewController:[[AccountSettingsViewController alloc] init] animated:YES];
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
