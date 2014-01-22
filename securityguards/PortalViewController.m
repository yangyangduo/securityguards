//
//  MainViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalViewController.h"
#import "Shared.h"
#import "XXDrawerViewController.h"
#import "RootViewController.h"
#import "UnitManager.h"

/*     components      */
#import "SensorsDisplayPanel.h"
#import "SpeechViewController.h"
#import "UnitSelectionDrawerView.h"
#import "UnitRenameViewController.h"

/*     events      */
#import "DeviceCommandNameEventFilter.h"
#import "XXEventFilterChain.h"
#import "NetworkModeChangedEvent.h"
#import "UnitsListUpdatedEvent.h"
#import "CurrentUnitChangedEvent.h"
#import "DeviceStatusChangedEvent.h"

#define IMAGE_VIEW_TAG 500

@interface PortalViewController ()

@end

@implementation PortalViewController {
    UIScrollView *scrollView;
    
    UILabel *lblHealthIndex;
    UILabel *lblHealthIndexGreatThan;
    
    SensorsDisplayPanel *sensorDisplayPanel;
    UnitControlPanel *controlPanelView;
    
    BOOL speechViewIsOpenning;
    UIImageView *imgNetwork;
    
    BOOL getAccountCommandHasSent;
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
    // update devices
    [self updateUnitsView];
    
    // update network state display
    [self updateNetworkStateForView:[CoreService defaultService].currentNetworkMode];
    
    XXEventNameFilter *eventNameFilter = [[XXEventNameFilter alloc] initWithSupportedEventNames:[NSArray arrayWithObjects:EventUnitsListUpdated, EventNetworkModeChanged, EventCurrentUnitChanged, EventUnitNameChanged, EventDeviceStatusChanged, nil]];
    
    DeviceCommandNameEventFilter *commandNameFilter = [[DeviceCommandNameEventFilter alloc] init];
    [commandNameFilter.supportedCommandNames addObject:COMMAND_GET_ACCOUNT];
    
    XXEventFilterChain *filterChain = [[XXEventFilterChain alloc] init];
    [[filterChain orFilter:eventNameFilter] orFilter:commandNameFilter];
    
    // subscribe events
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filterChain];
    subscription.notifyMustInMainThread = YES;
    
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    
    if(!getAccountCommandHasSent) {
        getAccountCommandHasSent = YES;
        [[CoreService defaultService] queueCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // unsubscribe events
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    speechViewIsOpenning = NO;
    getAccountCommandHasSent = NO;
}

- (void)initUI {
    [super initUI];
    
    /*
     * Create right button to show units list     
     */
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_drawer_right"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(showUnitSelectionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRight];
    
    UIButton *btnRename = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnRename setBackgroundImage:[UIImage imageNamed:@"btn_rename"] forState:UIControlStateNormal];
    [btnRename addTarget:self action:@selector(btnRenameUnit:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRename];
    
    /*
     * Create voice button view
     */
    UIView *voiceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 42, [UIScreen mainScreen].bounds.size.width, 42)];
    voiceBackgroundView.backgroundColor = [UIColor appGray];
    
    UIButton *btnVoice = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 556 / 2, 64 / 2)];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_gray"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_blue"] forState:UIControlStateHighlighted];
    [btnVoice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnVoice setTitle:NSLocalizedString(@"btn_voice_title", @"") forState:UIControlStateNormal];
    btnVoice.center = CGPointMake(voiceBackgroundView.center.x, btnVoice.center.y);
    [btnVoice addTarget:self action:@selector(showSpeechViewContoller:) forControlEvents:UIControlEventTouchUpInside];
    
    [voiceBackgroundView addSubview:btnVoice];
    [self.view addSubview:voiceBackgroundView];
    
    /*
     * Create scroll view
     */
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - voiceBackgroundView.bounds.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    /*
     * Create heathIndex view
     */
    UIImageView *imgHeathIndex = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    imgHeathIndex.tag = IMAGE_VIEW_TAG;
    imgHeathIndex.image = [UIImage imageNamed:@"bg_health_index"];
    
    lblHealthIndex = [[UILabel alloc] initWithFrame:CGRectMake(44, 34, 45, 50)];
    lblHealthIndex.backgroundColor = [UIColor clearColor];
    lblHealthIndex.text = @"30";
    lblHealthIndex.textColor = [UIColor whiteColor];
    lblHealthIndex.font = [UIFont boldSystemFontOfSize:26.f];
    lblHealthIndex.textAlignment = NSTextAlignmentCenter;
    [imgHeathIndex addSubview:lblHealthIndex];
    
    UILabel *lblDescription1 = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 190, 30)];
    UILabel *lblDescription2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 20, 30)];
    lblHealthIndexGreatThan = [[UILabel alloc] initWithFrame:CGRectMake(150, 52, 50, 40)];
    UILabel *lblDescription3 = [[UILabel alloc] initWithFrame:CGRectMake(197, 60, 100, 30)];
    
    [imgHeathIndex addSubview:lblDescription1];
    [imgHeathIndex addSubview:lblDescription2];
    [imgHeathIndex addSubview:lblHealthIndexGreatThan];
    [imgHeathIndex addSubview:lblDescription3];
    
    lblDescription1.textColor = [UIColor whiteColor];
    lblDescription2.textColor = [UIColor whiteColor];
    lblDescription3.textColor = [UIColor whiteColor];
    lblHealthIndexGreatThan.textColor = [UIColor yellowColor];
    
    lblDescription1.font = [UIFont systemFontOfSize:17.f];
    lblDescription2.font = [UIFont systemFontOfSize:17.f];
    lblDescription3.font = [UIFont systemFontOfSize:17.f];
    lblHealthIndexGreatThan.font = [UIFont systemFontOfSize:22.f];
    
    lblDescription1.text = NSLocalizedString(@"heath_index_desc1", @"");
    lblDescription2.text = NSLocalizedString(@"heath_index_desc2", @"");
    lblHealthIndexGreatThan.text = @"21%";
    lblDescription3.text = NSLocalizedString(@"heath_index_desc3", @"");
    
    lblDescription1.backgroundColor = [UIColor clearColor];
    lblDescription2.backgroundColor = [UIColor clearColor];
    lblHealthIndexGreatThan.backgroundColor = [UIColor clearColor];
    lblDescription3.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:imgHeathIndex];
    
    /*
     * Create sensors display view
     */
    sensorDisplayPanel = [[SensorsDisplayPanel alloc] initWithPoint:CGPointMake(0, imgHeathIndex.frame.origin.y + imgHeathIndex.frame.size.height)];
    [scrollView addSubview:sensorDisplayPanel];
    
    /*
     * Add blue line
     */
    UIImageView *imgLineBlue = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sensorDisplayPanel.bounds.size.width, 11)];
    imgLineBlue.image = [UIImage imageNamed:@"line_seperator_heavy_blue"];
    [sensorDisplayPanel addSubview:imgLineBlue];
    
    /*
     * Add separator line
     */
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, sensorDisplayPanel.bounds.size.height - 2, sensorDisplayPanel.bounds.size.width, 2)];
    imgLine.image = [UIImage imageNamed:@"line_dashed_h"];
    [sensorDisplayPanel addSubview:imgLine];
    
    /*
     * Create unit control panel view
     */
    controlPanelView = [[UnitControlPanel alloc] initWithPoint:CGPointMake(0, sensorDisplayPanel.frame.origin.y + sensorDisplayPanel.bounds.size.height)];
    
    controlPanelView.delegate = self;
    [scrollView addSubview:controlPanelView];
    
    [self resizeScrollView];
}

- (void)setUp {
    [super setUp];
    
    BOOL hasLogin = ![[XXStringUtils emptyString] isEqualToString:[GlobalSettings defaultSettings].secretKey];
    if(hasLogin) {
        [[CoreService defaultService] startService];
    } else {
        UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        loginNavController.navigationBarHidden = YES;
        [self presentViewController:loginNavController animated:NO completion:^{}];
    }
    
    controlPanelView.unit = [UnitManager defaultManager].currentUnit;
}

#pragma mark -
#pragma mark Unit Control View Delegate

- (void)unitControlPanelSizeChanged:(UnitControlPanel *)controlPanel {
    [self resizeScrollView];
}

#pragma mark -
#pragma mark UI Methods

- (void)resizeScrollView {
    CGFloat totalHeight = 0.f;
    for(UIView *view in scrollView.subviews) {
        if([view isKindOfClass:[UIImageView class]] && view.tag != IMAGE_VIEW_TAG) {
            continue;
        }
        totalHeight += view.bounds.size.height;
    }
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, totalHeight);
}

- (void)showUnitSelectionView:(id)sender {
    [[Shared shared].app.rootViewController showRightView];
}

- (void)showSpeechViewContoller:(id)sender {
    if(speechViewIsOpenning) return;
    if(self.parentViewController != nil) {
        speechViewIsOpenning = YES;
        SpeechViewController *speechViewController = [[SpeechViewController alloc] init];
        RootViewController *rootViewController = [Shared shared].app.rootViewController;
        [rootViewController addChildViewController:speechViewController];
        [self willMoveToParentViewController:nil];
        CGRect frame = speechViewController.view.frame;
        speechViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [rootViewController transitionFromViewController:self toViewController:speechViewController duration:0.8f options:UIViewAnimationOptionTransitionCrossDissolve
            animations:^{
            }
            completion:^(BOOL finished) {
                [speechViewController didMoveToParentViewController:rootViewController];
                [self removeFromParentViewController];
                [rootViewController setDisplayViewController:speechViewController];
                speechViewIsOpenning = NO;
            }];
    }
}

- (void)btnRenameUnit:(id)sender {
    Unit *currentUnit = [UnitManager defaultManager].currentUnit;
    if(currentUnit != nil) {
        UnitRenameViewController *unitRenameViewController = [[UnitRenameViewController alloc] initWithUnit:currentUnit];
        [self presentViewController:unitRenameViewController animated:YES completion:^{}];
    }
}

- (void)showNetworkStateView:(BOOL)isNoAllNetwork {
    if(imgNetwork == nil) {
        imgNetwork = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, 30)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 26)];
        lblDescription.tag = 100;
        lblDescription.textColor = [UIColor appYellowFont];
        lblDescription.textAlignment = NSTextAlignmentCenter;
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        [imgNetwork addSubview:lblDescription];
    }
    
    UILabel *lblDescription = (UILabel *)[imgNetwork viewWithTag:100];
    if(!isNoAllNetwork) {
        imgNetwork.image = [UIImage imageNamed:@"bg_alert_green"];
        lblDescription.text = NSLocalizedString(@"no_extra_network", @"");
    } else {
        imgNetwork.image = [UIImage imageNamed:@"bg_alert_yellow"];
        lblDescription.text = NSLocalizedString(@"no_network", @"");
    }
    
    if(imgNetwork.superview == nil) {
        [self.view addSubview:imgNetwork];
    }
}

- (void)hideNetworkStateView {
    if(imgNetwork != nil && imgNetwork.superview != nil) {
        [imgNetwork removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Event Subscriber

- (NSString *)xxEventSubscriberIdentifier {
    return @"portalViewControllerSubscriber";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[NetworkModeChangedEvent class]]) {
        NetworkModeChangedEvent *evt = (NetworkModeChangedEvent *)event;
        [self updateNetworkStateForView:evt.networkMode];
    } else if([event isKindOfClass:[UnitsListUpdatedEvent class]]
              || [event isKindOfClass:[CurrentUnitChangedEvent class]]) {
        [self updateUnitsView];
    } else if([event isKindOfClass:[DeviceStatusChangedEvent class]]) {
        [self updateUnitStatus:[UnitManager defaultManager].currentUnit];
    } else if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        if([evt.command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
            DeviceCommandUpdateAccount *cmd = (DeviceCommandUpdateAccount *)evt.command;
            LeftNavView *leftView = (LeftNavView *)[Shared shared].app.rootViewController.leftView;
            [leftView setScreenName:cmd.screenName];
        }
    }
}

#pragma mark -
#pragma mark Events notifications

- (void)updateUnitsView {
    Unit *currentUnit = [UnitManager defaultManager].currentUnit;
    if(currentUnit != nil) {
        self.topbarView.title = currentUnit.name;
//        NSData *dd = [JsonUtils createJsonDataFromDictionary:[currentUnit toJson]];
//        NSString *str = [[NSString alloc] initWithData:dd encoding:NSUTF8StringEncoding];
//        NSLog(@"<--------------------------------- \r\n %@", str);
        
        [sensorDisplayPanel setValue:18.5f forSensorType:SensorDisplayViewTypeTempure];
        [sensorDisplayPanel setValue:20.f forSensorType:SensorDisplayViewTypeHumidity];
        [sensorDisplayPanel setValue:3.f forSensorType:SensorDisplayViewTypePM25];
        [sensorDisplayPanel setValue:5.f forSensorType:SensorDisplayViewTypeVOC];

    } else {
        self.topbarView.title = NSLocalizedString(@"app_name", @"");
    }
    
    [self updateUnitStatus:currentUnit];
    [self updateUnitsSelectionView];
}

- (void)updateUnitStatus:(Unit *)unit {
    if(controlPanelView != nil) {
        [controlPanelView refreshWithUnit:unit];
    }
}

- (void)updateUnitsSelectionView {
    RootViewController *rootViewController = [Shared shared].app.rootViewController;
    if(rootViewController.rightView != nil) {
        UnitSelectionDrawerView *unitSelectionView = (UnitSelectionDrawerView *)rootViewController.rightView;
        [unitSelectionView refresh];
    }
}

- (void)updateNetworkStateForView:(NetworkMode)networkMode {
    if(networkMode == NetworkModeExternal) {
        if([CoreService defaultService].tcpService.isConnectted) {
            [self hideNetworkStateView];
        }
    } else if(networkMode == NetworkModeInternal) {
        [self showNetworkStateView:![CoreService defaultService].tcpService.isConnectted];
    } else if(networkMode == NetworkModeNotChecked) {
        [self showNetworkStateView:YES];
    } else {
        NSLog(@"[PORTAL VIEW] Unknow network mode.");
    }
}

- (void)reset {
    getAccountCommandHasSent = NO;
}

@end
