//
//  NotificationsViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsViewController.h"
#import "MessageCell.h"


@interface NotificationsViewController ()

@end

@implementation NotificationsViewController{
    UITableView *tblNotifications;
    NSMutableArray *messageArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    // subscribe events here
}

- (void)viewWillDisappear:(BOOL)animated {
    // unsubscribe events here
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"notifications_drawer_title", @"");
    if(tblNotifications == nil) {
        tblNotifications = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-self.topbarView.frame.size.height) style:UITableViewStylePlain];
        tblNotifications.dataSource = self;
        tblNotifications.delegate = self;
        tblNotifications.backgroundColor = [UIColor clearColor];
        tblNotifications.separatorStyle= UITableViewCellSelectionStyleNone;
        [self.view addSubview:tblNotifications];
    }

}

#pragma mark -
#pragma mark services

- (void)sort:(NSMutableArray *)arr ascending:(BOOL)ascending {
    if(arr != nil || arr.count == 0) return;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [arr sortUsingDescriptors:sortDescriptors];
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *messageCell = nil;
    SMNotification *notification = [messageArr objectAtIndex:indexPath.row];
    static NSString *messageIdentifier = @"messageCellIdentifier";
    messageCell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (messageCell == nil) {
        messageCell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageIdentifier];
        messageCell.backgroundColor = [UIColor clearColor];
    }
    [messageCell loadWithMessage:notification];
    
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  MESSAGE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMNotification *notificaion = [messageArr objectAtIndex:indexPath.row];
    NotificationDetailsViewController *notificationDetailsViewController = [[NotificationDetailsViewController alloc] initWithNotification:notificaion];
    notificationDetailsViewController.delegate = self;
    [self.navigationController pushViewController:notificationDetailsViewController animated:YES];
}

- (void)setUp {
    [super setUp];
}

@end
