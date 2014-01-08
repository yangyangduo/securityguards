//
//  NewsCell.m
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewsCell.h"
#import "UIColor+MoreColor.h"

@implementation NewsCell {
    UILabel *lblContent;
    UILabel *lblTime;
}

@synthesize content;
@synthesize dateTime;

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
    
    lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lblContent.numberOfLines = 2;
    lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:lblContent];
    [self addSubview:lblTime];
}

@end
