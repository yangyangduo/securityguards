//
//  MerchandiseCell.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseCell.h"

@implementation MerchandiseCell {
    UILabel *lblMerchandiseName;
    UILabel *lblMerchandiseDescriptions;
    UIImageView *imgMerchandise;
}

@synthesize merchandise = _merchandise_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
//    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];

    lblMerchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lblMerchandiseDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imgMerchandise = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self.contentView addSubview:lblMerchandiseName];
    [self.contentView addSubview:lblMerchandiseDescriptions];
    [self.contentView addSubview:imgMerchandise];
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
}

@end
