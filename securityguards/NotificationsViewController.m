//
//  NotificationsViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationsFileUpdatedEvent.h"
#import "MessageCell.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController{
    UITableView *tblNotifications;
    NSMutableArray *_notifications_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventName:EventNotificationsFileUpdated]];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

#pragma mark -
#pragma mark Event Subscriber

- (NSString *)xxEventSubscriberIdentifier {
    return @"notificationsViewControllerSubscriber";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    [self refresh];
}

- (void)initDefaults {
    [super initDefaults];
    _notifications_ = [NSMutableArray arrayWithArray:[[NotificationsFileManager fileManager] readFromDisk]];
    [self sort:_notifications_];
    [self markNotificationsAsRead:_notifications_];
}

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"notifications_drawer_title", @"");
    self.view.backgroundColor = [UIColor appGray];
    if(tblNotifications == nil) {
        tblNotifications = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height + 5, self.view.frame.size.width, self.view.frame.size.height - self.topbarView.frame.size.height - 5) style:UITableViewStylePlain];
        tblNotifications.center = CGPointMake(self.view.center.x, tblNotifications.center.y);
        tblNotifications.dataSource = self;
        tblNotifications.delegate = self;
        tblNotifications.backgroundColor = [UIColor clearColor];
        tblNotifications.separatorStyle= UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tblNotifications];
    }
}

- (void)setUp {
    [super setUp];
    if(_notifications_.count == 0) {
        [self showEmptyContentViewWithMessage:NSLocalizedString(@"empty_notifications", @"")];
    }
}

#pragma mark -
#pragma mark services

- (void)sort:(NSMutableArray *)notifications {
    if(notifications == nil || notifications.count == 0) return;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [notifications sortUsingDescriptors:sortDescriptors];
}

- (void)markNotificationsAsRead:(NSMutableArray *)notifications {
    if (notifications != nil && notifications.count > 0) {
        int unReadMessagesCount = 0;
        for(int i=0; i<notifications.count; i++) {
            SMNotification *notification = [notifications objectAtIndex:i];
            if(!notification.hasRead) {
                unReadMessagesCount++;
            }
            notification.hasRead = YES;
        }
#ifdef DEBUG
        NSLog(@"[Notifications View] number of %d unread messages was mark as read", unReadMessagesCount);
#endif
        [[NotificationsFileManager fileManager] update:notifications deleteList:nil];
    }
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notifications_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    MessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (messageCell == nil) {
        messageCell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        messageCell.backgroundColor = [UIColor clearColor];
    }
    SMNotification *notification = [_notifications_ objectAtIndex:indexPath.row];
    [messageCell loadWithMessage:notification];
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MESSAGE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMNotification *notificaion = [_notifications_ objectAtIndex:indexPath.row];
    NotificationDetailsViewController *notificationDetailsViewController = [[NotificationDetailsViewController alloc] initWithNotification:notificaion];
    notificationDetailsViewController.delegate = self;
    [self.navigationController pushViewController:notificationDetailsViewController animated:YES];
}

- (void)refresh {
    _notifications_ = [NSMutableArray arrayWithArray:[[NotificationsFileManager fileManager] readFromDisk]];
    if(_notifications_.count == 0) {
        [self showEmptyContentViewWithMessage:NSLocalizedString(@"empty_notifications", @"")];
    } else {
        [self removeEmptyContentView];
        [self sort:_notifications_];
    }
    [tblNotifications reloadData];
}

- (void)smNotificationsWasUpdated {
    [self refresh];
}

@end
