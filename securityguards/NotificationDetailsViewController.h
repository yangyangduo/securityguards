//
//  NotificationDetailsViewController.h
//  securityguards
//
//  Created by hadoop user account on 31/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@protocol SMNotificationDelegate <NSObject>

- (void)smNotificationsWasUpdated;

@end

@interface NotificationDetailsViewController : NavigationViewController

@property (strong,nonatomic) SMNotification *notification;
@property (assign, nonatomic) id<SMNotificationDelegate> delegate;

- (id)initWithNotification:(SMNotification *)notification;

@end
