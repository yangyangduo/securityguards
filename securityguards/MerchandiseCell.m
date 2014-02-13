//
//  MerchandiseCell.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseCell.h"
#import "MerchandiseBar.h"

@implementation MerchandiseCell {
    UILabel *lblMerchandiseName;
    UILabel *lblMerchandiseDescriptions;
    UIImageView *imgMerchandise;
    MerchandiseBar *merchandiseBar;
}

@synthesize merchandise = _merchandise_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
//    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    merchandiseBar = [[MerchandiseBar alloc] initWithPoint:CGPointMake(0, MerchandiseCellHeight - 44)];
    [self.contentView addSubview:merchandiseBar];
    
    lblMerchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(143, 3, 167, 25)];
    lblMerchandiseName.text = @"365家卫士主机";
    
    lblMerchandiseDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(143, 26, 172, 60)];
    lblMerchandiseDescriptions.numberOfLines = 3;
    lblMerchandiseDescriptions.font = [UIFont systemFontOfSize:12.f];
    lblMerchandiseDescriptions.textColor = [UIColor lightGrayColor];
    lblMerchandiseDescriptions.text = @"大祭司噢房间是滴哦飞的司机欧风就的司机欧风度搜房间的司机欧风度搜房间哦";
    
    imgMerchandise = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 128, 128)];
    imgMerchandise.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:imgMerchandise];
    [self.contentView addSubview:lblMerchandiseName];
    [self.contentView addSubview:lblMerchandiseDescriptions];
    
    
    [merchandiseBar setMerchandiseBarState:MerchandiseBarStateHighlighted merchandisePrice:1999.f merchandiseDescriptions:@"高配版, 白色 * 1"];
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
}

@end
