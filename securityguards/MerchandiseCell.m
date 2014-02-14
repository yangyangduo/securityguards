//
//  MerchandiseCell.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseCell.h"
#import "MerchandiseBar.h"
#import "ShoppingCart.h"

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
    
    lblMerchandiseDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(143, 26, 172, 60)];
    lblMerchandiseDescriptions.numberOfLines = 3;
    lblMerchandiseDescriptions.font = [UIFont systemFontOfSize:12.f];
    lblMerchandiseDescriptions.textColor = [UIColor lightGrayColor];
    
    imgMerchandise = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 128, 128)];
    imgMerchandise.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:imgMerchandise];
    [self.contentView addSubview:lblMerchandiseName];
    [self.contentView addSubview:lblMerchandiseDescriptions];
    
    PriceRange *range = [[PriceRange alloc] init];
    [range setSingleValue:0.f];
    [merchandiseBar setMerchandiseBarState:MerchandiseBarStateNormal merchandisePrice:range merchandiseDescriptions:@""];
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    if(_merchandise_ != nil) {
        lblMerchandiseName.text = merchandise.name;
        lblMerchandiseDescriptions.text = merchandise.shortIntroduce;
        ShoppingEntry *entry = [[ShoppingCart shoppingCart] shoppingEntryForId:merchandise.identifier];
        if(entry == nil) {
            PriceRange *range = [[PriceRange alloc] init];
            [range setValue:merchandise];
            [merchandiseBar setMerchandiseBarState:MerchandiseBarStateNormal merchandisePrice:range merchandiseDescriptions:@""];
        } else {
            PriceRange *range = [[PriceRange alloc] initWithSingleValue:entry.model == nil ? 0.f : entry.model.price];
            [merchandiseBar setMerchandiseBarState:MerchandiseBarStateHighlighted merchandisePrice:range merchandiseDescriptions:[entry shoppingEntryDetailsAsString]];
        }
    } else {
        lblMerchandiseName.text = [XXStringUtils emptyString];
        lblMerchandiseDescriptions.text = [XXStringUtils emptyString];
        [merchandiseBar setMerchandiseBarState:MerchandiseBarStateNormal merchandisePrice:[[PriceRange alloc] initWithSingleValue:0.f] merchandiseDescriptions:@""];
    }
}

@end
