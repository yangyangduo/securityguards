//
//  RootViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RootViewController.h"
#import "NewsViewController.h"
#import "UserManagementViewController.h"
#import "ContactUsViewController.h"
#import "UnitSelectionDrawerView.h"
#import "TimingTasksPlanViewController.h"
#import "NotificationsViewController.h"
#import "UserLogoutEvent.h"
#import "UnitManager.h"
#import "ShoppingViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController {
    PortalViewController *portalViewController;
    UserManagementViewController *userManagementViewController;
}

@synthesize displayViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // init left view
    NSArray *navItems = [NSArray arrayWithObjects:
        [[LeftNavItem alloc] initWithIdentifier:@"portalItem" andDisplayName:NSLocalizedString(@"portal_drawer_title", @"") andImageName:@"icon_portal"],
        [[LeftNavItem alloc] initWithIdentifier:@"shoppingItem" andDisplayName:NSLocalizedString(@"shopping_title", @"") andImageName:@"icon_shopping"],
        [[LeftNavItem alloc] initWithIdentifier:@"newsItem" andDisplayName:NSLocalizedString(@"news_drawer_title", @"") andImageName:@"icon_news"],
        [[LeftNavItem alloc] initWithIdentifier:@"notificationsItem" andDisplayName:NSLocalizedString(@"notifications_drawer_title", @"") andImageName:@"icon_notifications"],
        [[LeftNavItem alloc] initWithIdentifier:@"timerTaskItem" andDisplayName:NSLocalizedString(@"task_timer_title", @"") andImageName:@"icon_timer"],
        [[LeftNavItem alloc] initWithIdentifier:@"accountManagerItem" andDisplayName:NSLocalizedString(@"user_mgr_drawer_title", @"") andImageName:@"icon_account"],
        [[LeftNavItem alloc] initWithIdentifier:@"contactUsItem" andDisplayName:NSLocalizedString(@"contact_us_drawer_title", @"") andImageName:@"icon_copyright"],
        [[LeftNavItem alloc] initWithIdentifier:@"logoutItem" andDisplayName:NSLocalizedString(@"logout_drawer_title", @"") andImageName:@"icon_logout"], nil];
    
    LeftNavView *navView = [[LeftNavView alloc] initWithFrame:[UIScreen mainScreen].bounds andNavItems:navItems];
    navView.delegate = self;
    self.leftView = navView;
    
    self.centerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // init center view
    if(navItems.count > 0) {
        [self leftNavViewItemChanged:[navItems objectAtIndex:0]];
    }
    
    // init right view
    
    UnitSelectionDrawerView *unitSelectionView = [[UnitSelectionDrawerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    unitSelectionView.weakRootViewController = self;
    self.rightView = unitSelectionView;
    
    self.leftViewVisibleWidth = 160;
    self.showDrawerMaxTrasitionX = 50;
    self.rightViewVisibleWidth = 160;
    self.rightViewCenterX = 200;
    
    // setup
    [self initialDrawerViewController];
    
    [self subscribeEvents];
}

#pragma mark -
#pragma mark Left Nav View Delegate

- (void)leftNavViewItemChanged:(LeftNavItem *)item {
    // if the item is nil, we think it not changed
    if(item == nil) {
        [self showCenterView:YES];
        return;
    }
    
    UIViewController *centerViewController = nil;
    
    // get CenterViewController
    if([@"portalItem" isEqualToString:item.identifier]) {
        if(portalViewController == nil) {
            portalViewController = [[PortalViewController alloc] init];
        }
        centerViewController = portalViewController;
    } else if([@"shoppingItem" isEqualToString:item.identifier]) {
        centerViewController = [[ShoppingViewController alloc] init];
    } else if([@"newsItem" isEqualToString:item.identifier]) {
        centerViewController = [[NewsViewController alloc] init];
    } else if([@"notificationsItem" isEqualToString:item.identifier]) {
        centerViewController = [[NotificationsViewController alloc] init];
    } else if([@"timerTaskItem" isEqualToString:item.identifier]) {
        centerViewController = [[TimingTasksPlanViewController alloc] initWithUnit:[UnitManager defaultManager].currentUnit];
    } else if([@"accountManagerItem" isEqualToString:item.identifier]) {
        if(userManagementViewController == nil) {
            userManagementViewController = [[UserManagementViewController alloc] init];
        }
        centerViewController = userManagementViewController;
    } else if([@"contactUsItem" isEqualToString:item.identifier]) {
        centerViewController = [[ContactUsViewController alloc] init];
    }
    
    if(centerViewController == nil) return;
    
    // will add center view controller and remove last center view controller called (display view controller) here.
    [self addChildViewController:centerViewController];
    if(self.displayViewController != nil) {
        [self.displayViewController willMoveToParentViewController:nil];
    }
    
    // did add center view controller and ...
    
    // why do this below
    // in IOS7 Status bar will auto add 20px for orgin y in Navigation View Controller
    // 这里还是来一段中文比较靠谱， 不然自己都看不懂，在IOS7 下面如果使用了Navigation View Controller
    // 那么所有的View Controller 的frame.orgin.y 都会被设置成 20
    CGRect frame = centerViewController.view.frame;
    centerViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    self.centerView = centerViewController.view;
    [centerViewController didMoveToParentViewController:self];
    if(self.displayViewController != nil) {
        [self.displayViewController removeFromParentViewController];
    }
    
    // set center view controller as display view controller
    self.displayViewController = centerViewController;
    [self showCenterView:YES];
    
    self.rightViewEnable = [@"portalItem" isEqualToString:item.identifier];
}

- (void)subscribeEvents {
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventName:EventUserLogout]];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)changeViewControllerWithIdentifier:(NSString *)identifier {
    if(self.displayViewController == nil) return;
    if(self.leftView == nil) return;
    
    LeftNavView *leftNavView = (LeftNavView *)self.leftView;
    if(leftNavView.currentItem == nil) return;

    // create will selected item
    LeftNavItem *item = [[LeftNavItem alloc] init];
    item.identifier = identifier;
    
    leftNavView.currentItem = item; 
    [self leftNavViewItemChanged:leftNavView.currentItem];
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[UserLogoutEvent class]]) {
        [self userHasLogout];
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"rootViewControllerSubscriber";
}

- (void)userHasLogout {
    if(self.leftView != nil) {
        LeftNavView *leftNavView = (LeftNavView *)self.leftView;
        [leftNavView reset];
    }
    
    if(self.displayViewController != nil) {
        if(self.displayViewController != portalViewController) {
            LeftNavItem *portalItem = [[LeftNavItem alloc] init];
            portalItem.identifier = @"portalItem";
            [self leftNavViewItemChanged:portalItem];
            return;
        }
    }
    
    [self showCenterView:NO];
}

- (PortalViewController *)portalViewController {
    return portalViewController;
}

@end

