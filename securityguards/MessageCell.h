//
//  MessageCell.h
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNotification.h"

#define MESSAGE_CELL_HEIGHT 80
#define TYPE_IMAGE_TAG 1001
#define TEXT_LABEL_TAG 1000
#define CELL_VIEW_TAG 999

@interface MessageCell : UITableViewCell

@property (strong,nonatomic) SMNotification *notificaion;

- (void)loadWithMessage:(SMNotification *)message;

@end
