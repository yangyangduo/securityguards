//
//  MainViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalViewController.h"
#import "SensorsDisplayPanel.h"
#import "UnitControlPanel.h"
#import "XXDrawerViewController.h"
#import "NetworkModeChangedEvent.h"
#import "RootViewController.h"
#import "SpeechViewController.h"
#import "UnitsListUpdatedEvent.h"
#import "UnitSelectionDrawerView.h"
#import "UnitManager.h"
#import "CurrentUnitChangedEvent.h"

@interface PortalViewController ()

@end

@implementation PortalViewController {
    UIScrollView *scrollView;
    
    UILabel *lblHealthIndex;
    UILabel *lblHealthIndexGreatThan;
    
    UnitControlPanel *controlPanelView;
    
    BOOL speechViewIsOpenning;
    UIImageView *imgNetwork;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    BOOL hasLogin = ![[XXStringUtils emptyString] isEqualToString:[GlobalSettings defaultSettings].secretKey];
    if(hasLogin) {
        [[CoreService defaultService] startService];
    } else {
        [self showLoginViewController];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // update devices
    [self updateUnitsView];
    
    // update network state display
    [self updateNetworkStateForView:[CoreService defaultService].currentNetworkMode];
    
    // subscribe events
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventNames:[NSArray arrayWithObjects:EventUnitsListUpdated, EventNetworkModeChanged, EventCurrentUnitChanged, nil]]];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
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
}

- (void)initUI {
    [super initUI];
    
    /*
     * Create right button to show units list     
     */
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 8 - 55 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? (20 + 8) : 8, 55 / 2, 55 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_drawer_right"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(showUnitSelectionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRight];
    
    UIButton *btnRename = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 8 - 55 - 5), [UIDevice systemVersionIsMoreThanOrEuqal7] ? (20 + 8) : 8, 55 / 2, 55 / 2)];
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
    scrollView.backgroundColor = [UIColor appGray];
    [self.view addSubview:scrollView];
    
    /*
     * Create heathIndex view
     */
    UIImageView *imgHeathIndex = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
    imgHeathIndex.image = [UIImage imageNamed:@"bg_health_index"];
    [scrollView addSubview:imgHeathIndex];
    
    lblHealthIndex = [[UILabel alloc] initWithFrame:CGRectMake(44, 34, 45, 50)];
    lblHealthIndex.backgroundColor = [UIColor clearColor];
    lblHealthIndex.text = @"99";
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
    lblHealthIndexGreatThan.text = @"81%";
    lblDescription3.text = NSLocalizedString(@"heath_index_desc3", @"");
    
    lblDescription1.backgroundColor = [UIColor clearColor];
    lblDescription2.backgroundColor = [UIColor clearColor];
    lblHealthIndexGreatThan.backgroundColor = [UIColor clearColor];
    lblDescription3.backgroundColor = [UIColor clearColor];
    
    /*
     * Create sensors display view
     */
    SensorsDisplayPanel *sensorDisplayPanel = [[SensorsDisplayPanel alloc] initWithPoint:CGPointMake(0, imgHeathIndex.frame.origin.y + imgHeathIndex.frame.size.height)];
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
    [scrollView addSubview:controlPanelView];
    
    CGFloat totalHeight = 0.f;
    for(UIView *view in scrollView.subviews) {
        totalHeight += view.bounds.size.height;
    }
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, totalHeight);
}

- (void)setUp {
}

// Clear user's data for view
- (void)clear {
    [super clear];
}

#pragma mark -
#pragma mark UI Methods

- (void)showUnitSelectionView:(id)sender {
    if(self.parentViewController != nil && self.parentViewController.parentViewController != nil) {
        if([self.parentViewController.parentViewController isKindOfClass:[XXDrawerViewController class]]) {
            XXDrawerViewController *drawerController = (XXDrawerViewController *)self.parentViewController.parentViewController;
            [drawerController showRightView];
        }
    }
}

- (void)showSpeechViewContoller:(id)sender {
    if(speechViewIsOpenning) return;
    if(self.parentViewController != nil) {
        speechViewIsOpenning = YES;
        SpeechViewController *speechViewController = [[SpeechViewController alloc] init];
        RootViewController *rootViewController = (RootViewController *)self.parentViewController.parentViewController;
        [rootViewController addChildViewController:speechViewController];
        [self.parentViewController willMoveToParentViewController:nil];
        [rootViewController transitionFromViewController:self.parentViewController toViewController:speechViewController duration:0.8f options:UIViewAnimationOptionTransitionCrossDissolve
            animations:^{
            }
            completion:^(BOOL finished) {
                [speechViewController didMoveToParentViewController:rootViewController];
                [self.parentViewController removeFromParentViewController];
                [rootViewController setDisplayViewController:speechViewController];
                speechViewIsOpenning = NO;
            }];
    }
}

- (void)btnRenameUnit:(id)sender {
    TextViewController *txtViewController = [[TextViewController alloc] init];
    txtViewController.txtDescription = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"enter_new_unit_name", @"")];
    txtViewController.title = NSLocalizedString(@"rename_unit", @"");
    if([UnitManager defaultManager].currentUnit != nil) {
        txtViewController.defaultValue = [UnitManager defaultManager].currentUnit.name;
    }
    [self presentViewController:txtViewController animated:YES completion:^{}];
}

- (void)showNetworkStateView {
    if(imgNetwork == nil) {
        imgNetwork = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, 30)];
        imgNetwork.image = [UIImage imageNamed:@"bg_alert_yellow"];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 26)];
        lblDescription.textColor = [UIColor appYellowFont];
        lblDescription.textAlignment = NSTextAlignmentCenter;
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.text = NSLocalizedString(@"no_network", @"");
        [imgNetwork addSubview:lblDescription];
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
    }
}

#pragma mark -
#pragma mark View updates

- (void)updateUnitsView {
    Unit *currentUnit = [UnitManager defaultManager].currentUnit;
    if(currentUnit != nil) {
        self.topbarView.title = currentUnit.name;
        
NSData *dd =        [JsonUtils createJsonDataFromDictionary:
         [currentUnit toJson]];
NSString *str =        [[NSString alloc] initWithData:dd encoding:NSUTF8StringEncoding];
        NSLog(str);
        
    } else {
        self.topbarView.title = NSLocalizedString(@"app_name", @"");
    }
    [self updateUnitsSelectionView];
}

- (void)updateUnitsSelectionView {
    if(self.parentViewController == nil || self.parentViewController.parentViewController == nil) return;
    RootViewController *rootViewController = (RootViewController *)self.parentViewController.parentViewController;
    if(rootViewController.rightView != nil) {
        UnitSelectionDrawerView *unitSelectionView = (UnitSelectionDrawerView *)rootViewController.rightView;
        [unitSelectionView refresh];
    }
}

- (void)updateNetworkStateForView:(NetworkMode)networkMode {
    if(networkMode == NetworkModeExternal) {
        [self hideNetworkStateView];
    } else if(networkMode == NetworkModeInternal) {
        [self hideNetworkStateView];
    } else if(networkMode == NetworkModeNotChecked) {
        [self showNetworkStateView];
    } else {
        NSLog(@"[PORTAL VIEW] Unknow network mode.");
    }
}

@end
