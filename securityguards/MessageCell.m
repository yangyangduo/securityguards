//
//  MessageCell.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageCell.h"
#import "XXDateFormatter.h"
#import "UIColor+MoreColor.h"

@implementation MessageCell {
    UIView  *view;
    UIImageView *typeMessage;
    UILabel *textLabel;
    UILabel *lblTime;
}

@synthesize notificaion;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
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

    if (typeMessage == nil) {
        typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 76/2, 64/2)];
        typeMessage.backgroundColor = [UIColor clearColor];
        typeMessage.tag = TYPE_IMAGE_TAG;
    }
    UIImageView *imgSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 2, 65)];
    imgSeperator.image = [UIImage imageNamed:@"line_news"];
    
    if (textLabel == nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 180, 42)];
        textLabel.tag = TEXT_LABEL_TAG;
        textLabel.font =[UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.numberOfLines = 2;
        textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (lblTime == nil) {
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(80, 46, 240, 18)];
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor darkGrayColor];
        lblTime.font = [UIFont systemFontOfSize:11];
    }
    
    if(view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width, MESSAGE_CELL_HEIGHT-5)];
        view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        typeMessage.center = CGPointMake(typeMessage.center.x, view.center.y);
        [view addSubview:typeMessage];
        [view addSubview:imgSeperator];
        [view addSubview:textLabel];
        UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_accessory.png"]];
        accessory.backgroundColor = [UIColor clearColor];
        accessory.frame = CGRectMake(view.frame.size.width-50, 28, 16/2, 41/2);
        accessory.center = CGPointMake(accessory.center.x, view.center.y-5);
        [view addSubview:accessory];
        
        [view addSubview:lblTime];
        view.tag = CELL_VIEW_TAG;
        [self addSubview:view];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)loadWithMessage:(SMNotification *)message {
    if([@"MS" isEqualToString:message.type] || [@"AT" isEqualToString:message.type]) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    } else if([@"CF" isEqualToString:message.type]) {
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    } else if([@"AL" isEqualToString:message.type]){
        typeMessage.image = [UIImage imageNamed:@"icon_warning"];
    }
    textLabel.text = [@"    " stringByAppendingString:message.text];
    [textLabel sizeThatFits:textLabel.frame.size];
    lblTime.text = [XXDateFormatter dateToString:message.createTime format:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
