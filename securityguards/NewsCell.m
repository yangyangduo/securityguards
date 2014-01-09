//
//  NewsCell.m
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewsCell.h"
#import "UIColor+MoreColor.h"
#import "XXStringUtils.h"

@implementation NewsCell {
    UILabel *lblContent;
    UILabel *lblTime;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)init {
    self = [super init];
    if(self) {
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
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 65)];
    backgroundView.backgroundColor = [UIColor appWhite];
    [self.backgroundView addSubview:backgroundView];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 65)];
    selectedBackgroundView.backgroundColor = [UIColor appDarkGray];
    [self.selectedBackgroundView addSubview:selectedBackgroundView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(23.5f, 33.f / 2 + 5, 67.f / 2, 64.f / 2)];
    imgView.image = [UIImage imageNamed:@"icon_star"];
    [self addSubview:imgView];
    
    UIImageView *imgSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(70, 5, 2, 65)];
    imgSeperator.image = [UIImage imageNamed:@"line_news"];
    [self addSubview:imgSeperator];
    
    lblContent = [[UILabel alloc] initWithFrame:CGRectMake(imgSeperator.frame.origin.x + 10, 7, 210, 42)];
    lblContent.numberOfLines = 2;
    lblContent.backgroundColor = [UIColor clearColor];
    lblContent.textColor = [UIColor darkGrayColor];
    lblContent.font = [UIFont systemFontOfSize:13.f];
    lblTime = [[UILabel alloc] initWithFrame:CGRectMake(lblContent.frame.origin.x, lblContent.frame.origin.y + lblContent.bounds.size.height, 120, 18)];
    lblTime.textColor = [UIColor darkGrayColor];
    lblTime.backgroundColor = [UIColor clearColor];
    lblTime.font = [UIFont systemFontOfSize:11.f];
    
    [self addSubview:lblContent];
    [self addSubview:lblTime];
    
    UIImageView *imgDisclosure =  [[UIImageView alloc] initWithFrame:CGRectMake(backgroundView.bounds.size.width - 5, (65 - 41.f / 2) / 2 + 5, 16 / 2, 41.f / 2)];
    imgDisclosure.image = [UIImage imageNamed:@"icon_ disclosure"];
    [self addSubview:imgDisclosure];
}

- (void)setContent:(NSString *)content {
    lblContent.text = [XXStringUtils isBlank:content] ? [XXStringUtils emptyString] : content;
}

- (void)setCreateTime:(NSString *)createTime {
    lblTime.text = [XXStringUtils isBlank:createTime] ? [XXStringUtils emptyString] : createTime;
}

@end
