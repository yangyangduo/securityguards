//
//  ConversationTextMessage.h
//  SmartHome
//
//  Created by Zhao yang on 8/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationMessage.h"

@interface ConversationTextMessage : ConversationMessage

@property (strong, nonatomic) NSString *textMessage;
@property (strong, nonatomic) NSString *statusMessage;
@property (strong, nonatomic) NSString *timeMessage;

@end
