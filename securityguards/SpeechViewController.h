//
//  SpeechViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"
#import "ConversationMessage.h"

@interface SpeechViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate>

- (id)initWithMessages:(NSArray *)messages;

- (void)clearAllMessages;
- (void)addMessage:(ConversationMessage *)message;

@end
