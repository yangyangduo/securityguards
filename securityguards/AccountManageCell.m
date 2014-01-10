//
//  AccountManageCell.m
//  securityguards
//
//  Created by hadoop user account on 9/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AccountManageCell.h"
#import "UIColor+HexColor.h"
#import "UIDevice+SystemVersion.h"

@implementation AccountManageCell{
    UIImageView *imgUserStatus;
    UILabel *lblUserInfo;
    UIImageView *imgAccessory;
}
@synthesize data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(AccountManageCellData *) cellData
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        data = cellData;
        [self initUI];
        
    }
    return self;
}
- (void) initUI{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, CELL_WIDTH, CELL_HEIGHT-10)];
    view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    view.center = self.center;
    [self addSubview:view];
    
    if (!data.isPanel) {
        UIView *ySeperatorView1 = [[UIView alloc] initWithFrame:CGRectMake(58, 0, 1, CELL_HEIGHT-10)];
        ySeperatorView1.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        [view addSubview:ySeperatorView1];
        
        UIView *ySeperatorView2 = [[UIView alloc] initWithFrame:CGRectMake(59, 0, 1, CELL_HEIGHT-10)];
        ySeperatorView2.backgroundColor = [UIColor whiteColor];
        [view addSubview:ySeperatorView2];
        
        if (imgUserStatus == nil) {
            imgUserStatus = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44/2, 34/2)];
            imgUserStatus.center = CGPointMake(30, view.center.y);
            imgUserStatus.backgroundColor = [UIColor clearColor];
            [view addSubview:imgUserStatus];
        }
        
        if (lblUserInfo == nil) {
            lblUserInfo = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 160, CELL_HEIGHT-10)];
            lblUserInfo.center = CGPointMake(lblUserInfo.center.x, view.center.y);
            lblUserInfo.textColor = [UIColor darkGrayColor];
            lblUserInfo.backgroundColor = [UIColor clearColor];
            lblUserInfo.font = [UIFont systemFontOfSize:13.f];
            if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
                lblUserInfo.textColor = [UIColor lightGrayColor];
            }
            [view addSubview:lblUserInfo];
        }
        
        if (imgAccessory == nil) {
            imgAccessory = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_WIDTH-40, 0, 45/2, 44/2)];
            imgAccessory.center = CGPointMake(imgAccessory.center.x, view.center.y);
            imgAccessory.image = [UIImage imageNamed:@"icon_yellow_accessory.png"];
            [view addSubview:imgAccessory];
        }

    }
}

- (void)loadData{

    User *user = data.user;
    if(user != nil) {
        lblUserInfo.text = [NSString stringWithFormat:@"%@(%@)" ,user.name,user.mobile];
        if(user.isCurrentUser) {
            if (user.userState == UserStateOnline) {
                imgUserStatus.image = [UIImage imageNamed:user.isOwner ? @"icon_me_owner.png" : @"icon_me.png"];
            }else{
                imgUserStatus.image = [UIImage imageNamed:user.isOwner ? @"icon_me_owner.png" : @"icon_me_offline.png"];
            }
        } else {
            if (user.userState == UserStateOnline) {
                imgUserStatus.image = [UIImage imageNamed:user.isOwner ? @"icon_owner.png" : @"transparent.png"];
            }else{
                imgUserStatus.image = [UIImage imageNamed:user.isOwner ? @"icon_owner_offline.png" : @"transparent.png"];
            }
        }
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
