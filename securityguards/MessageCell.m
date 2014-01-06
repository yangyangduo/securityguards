//
//  MessageCell.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageCell.h"
#import "XXDateFormatter.h"

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
    if (typeMessage == nil) {
        typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 76/2, 64/2)];
        typeMessage.backgroundColor = [UIColor clearColor];
        typeMessage.tag = TYPE_IMAGE_TAG;
    }
    UIView *ySeperatorView1 = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 1, MESSAGE_CELL_HEIGHT-10)];
    ySeperatorView1.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    UIView *ySeperatorView2 = [[UIView alloc] initWithFrame:CGRectMake(51, 0, 1, MESSAGE_CELL_HEIGHT-10)];
    ySeperatorView2.backgroundColor = [UIColor whiteColor];

    
    if (textLabel == nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 180,MESSAGE_CELL_HEIGHT-30)];
        textLabel.tag = TEXT_LABEL_TAG;
        textLabel.font =[UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = [UIColor blackColor];
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        textLabel.numberOfLines = 0;
        textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (lblTime == nil) {
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(60, MESSAGE_CELL_HEIGHT-25, 240, 15)];
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor blackColor];
        lblTime.font = [UIFont systemFontOfSize:8];
    }
    
    
    if(view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, MESSAGE_CELL_HEIGHT-10)];
        view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        typeMessage.center = CGPointMake(typeMessage.center.x, view.center.y-10);
        [view addSubview:typeMessage];
        [view addSubview:ySeperatorView1];
        [view addSubview:ySeperatorView2];
        [view addSubview:textLabel];
        UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_accessory.png"]];
        accessory.backgroundColor = [UIColor clearColor];
        accessory.frame = CGRectMake(view.frame.size.width-40, 28, 16/2, 41/2);
        accessory.center = CGPointMake(accessory.center.x, view.center.y-10);
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
