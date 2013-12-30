//
//  ConversationMessage.h
//  SmartHome
//
//  Created by Zhao yang on 8/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MESSAGE_OWNER) {
    MESSAGE_OWNER_MINE,
    MESSAGE_OWNER_THEIRS
};

@interface ConversationMessage : NSObject

// properties

@property (assign, nonatomic) MESSAGE_OWNER messageOwner;


// methods

- (UIView *)viewWithMessage:(CGFloat)tblConversationWidth;

@end
