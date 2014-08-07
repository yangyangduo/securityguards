//
//  MainViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalViewController.h"
#import "Shared.h"
#import "UnitDetailsViewController.h"
#import "UnitManager.h"
#import "AQIManager.h"
#import "NotificationsFileManager.h"

/*     components      */
#import "SensorsDisplayPanel.h"
#import "SpeechViewController.h"
#import "SceneVoiceView.h"
#import "UnitSelectionDrawerView.h"
#import "AQIPanelView.h"

/*     events      */
#import "DeviceCommandNameEventFilter.h"
#import "XXEventFilterChain.h"
#import "NetworkModeChangedEvent.h"
#import "UnitsListUpdatedEvent.h"
#import "CurrentUnitChangedEvent.h"
#import "DeviceStatusChangedEvent.h"
#import "SensorStateChangedEvent.h"
#import "CurrentLocationUpdatedEvent.h"
#import "NotificationsFileUpdatedEvent.h"
#import "ScoreChangedEvent.h"

/* baidu share kit */
#import <Frontia/Frontia.h>

#define IMAGE_VIEW_TAG 500

@interface PortalViewController ()

@end

@implementation PortalViewController {
    UIScrollView *scrollView;
    
    UIImageView *imgHeathIndex;
    UILabel *lblHealthIndex;

    SensorsDisplayPanel *sensorDisplayPanel;
    UnitControlPanel *controlPanelView;
    
    AQIPanelView *aqiPanelView;
    
    BOOL speechViewIsOpening;
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
    if([UnitManager defaultManager].currentUnit != nil) {
        [self updateUnitScoreViewWithScore:[UnitManager defaultManager].currentUnit.score];
    }
    
    XXEventNameFilter *eventNameFilter =
            [[XXEventNameFilter alloc] initWithSupportedEventNames:
                    [NSArray arrayWithObjects:
                            EventUnitsListUpdated, EventNetworkModeChanged, EventCurrentUnitChanged,
                            EventUnitNameChanged, EventDeviceStatusChanged, EventSensorStateChanged,
                            EventCurrentLocationUpdated, EventScoreChanged, EventNotificationsFileUpdated, nil]];
    
    DeviceCommandNameEventFilter *commandNameFilter = [[DeviceCommandNameEventFilter alloc] init];
    [commandNameFilter.supportedCommandNames addObject:COMMAND_GET_ACCOUNT];
    
    XXEventFilterChain *filterChain = [[XXEventFilterChain alloc] init];
    [[filterChain orFilter:eventNameFilter] orFilter:commandNameFilter];
    
    // subscribe events
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filterChain];
    subscription.notifyMustInMainThread = YES;
    
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    
    // get account command only execute once
    if(!getAccountCommandHasSent) {
        getAccountCommandHasSent = YES;
        [[CoreService defaultService] queueCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // un subscribe events
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)viewDidAppear:(BOOL)animated {
    // update network state display
    [self updateNetworkStateForView:[CoreService defaultService].netMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    speechViewIsOpening = NO;
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
     * Create scroll view
     */
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    /*
     * Create heathIndex view
     */
    imgHeathIndex = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SENSOR_DISPLAY_PANEL_HEIGHT)];
    imgHeathIndex.userInteractionEnabled = YES;
    imgHeathIndex.tag = IMAGE_VIEW_TAG;
    imgHeathIndex.backgroundColor = [UIColor appWhite];
    imgHeathIndex.image = [UIImage imageNamed:@"img_portal_header"];

    UIImageView *imgCircleBackground = [[UIImageView alloc] initWithFrame:CGRectMake(25, 14, 177.f / 2, 177.f / 2)];
    imgCircleBackground.image = [UIImage imageNamed:@"bg_circle"];
    [imgHeathIndex addSubview:imgCircleBackground];

    lblHealthIndex = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 90)];
    lblHealthIndex.backgroundColor = [UIColor clearColor];
    lblHealthIndex.text = @"--";
    lblHealthIndex.textColor = [UIColor colorWithRed:10.f / 255.f green:217.f / 255.f blue:1.f alpha:1.0];
    lblHealthIndex.font = [UIFont systemFontOfSize:50.f];
    lblHealthIndex.shadowColor = [UIColor whiteColor];
    lblHealthIndex.textAlignment = NSTextAlignmentCenter;
    lblHealthIndex.shadowOffset = CGSizeMake(2, 2);
    [imgHeathIndex addSubview:lblHealthIndex];

    UIImageView *imgSeparatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 2, 150)];
    imgSeparatorLine.center = CGPointMake(imgSeparatorLine.center.x, imgHeathIndex.bounds.size.height / 2);
    imgSeparatorLine.image = [UIImage imageNamed:@"line_portal_blue_seperator"];
    [imgHeathIndex addSubview:imgSeparatorLine];

    UILabel *lblShareTips = [[UILabel alloc] initWithFrame:CGRectMake(37, 115, 90, 25)];
    lblShareTips.text = NSLocalizedString(@"share_my_data", @"");
    lblShareTips.textAlignment = NSTextAlignmentCenter;
    lblShareTips.backgroundColor = [UIColor clearColor];
    lblShareTips.font = [UIFont boldSystemFontOfSize:14.f];
    lblShareTips.textColor = [UIColor colorWithRed:10.f / 255.f green:217.f / 255.f blue:1.f alpha:1.0];
    UITapGestureRecognizer *shareTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnSharePressed:)];
    [lblShareTips addGestureRecognizer:shareTapGestureRecognizer];
    lblShareTips.userInteractionEnabled = YES;
    [imgHeathIndex addSubview:lblShareTips];

    UIButton *btnShare = [[UIButton alloc] initWithFrame:
            CGRectMake(lblShareTips.frame.origin.x - 20, lblShareTips.frame.origin.y + 3, 29.f / 2, 37.f / 2)];
    [btnShare addTarget:self action:@selector(btnSharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [imgHeathIndex addSubview:btnShare];

    /*
     * Create sensors display view
     */
    sensorDisplayPanel = [[SensorsDisplayPanel alloc] initWithPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2 - 10, 0)];
    [imgHeathIndex addSubview:sensorDisplayPanel];
    [scrollView addSubview:imgHeathIndex];

    /*
     * -------------  Separator line ---------------
     */
    UIImageView *separatorLineForImgHealthIndex = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgHeathIndex.bounds.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLineForImgHealthIndex.image = [UIImage imageNamed:@"line_dashed_white"];
    [imgHeathIndex addSubview:separatorLineForImgHealthIndex];

    /*
     * Create scene and voice view
     */
    SceneVoiceView *sceneVoiceView = [[SceneVoiceView alloc] initWithPoint:CGPointMake(0, imgHeathIndex.frame.origin.y + imgHeathIndex.bounds.size.height)];
    [scrollView addSubview:sceneVoiceView];

    /*
     * Add separator line for scene voice view
     */
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, sceneVoiceView.bounds.size.height - 2, sceneVoiceView.bounds.size.width, 2)];
    imgLine.image = [UIImage imageNamed:@"line_dashed_h"];
    [sceneVoiceView addSubview:imgLine];

    /*
     * Create unit control panel view
     */
    controlPanelView = [[UnitControlPanel alloc] initWithPoint:CGPointMake(0, sceneVoiceView.frame.origin.y + sceneVoiceView.bounds.size.height)];
    controlPanelView.delegate = self;
    [scrollView addSubview:controlPanelView];

    /* re-size scroll view */
    if(![self updateAQIPanelViewWithAqi:[AQIManager manager].currentAqiInfo]) {
        [self resizeScrollView];
    }
}

- (void)btnSharePressed:(id)sender {
    int score = [UnitManager defaultManager].currentUnit.score.score;
    int ranking = [UnitManager defaultManager].currentUnit.score.rankings;
    
    FrontiaShareContent *content = [[FrontiaShareContent alloc] init];
    content.url = @"http://365smart.com";
    content.title = @"365家卫士";
    
    if(score != 0) {
        content.description = [NSString stringWithFormat:@"当前我的家庭健康及安全指数为 %d 分, 已超过 %d%% 的家庭 ", score, ranking];
    } else {
        content.description = @"我的健康安全防护专家，365家卫士家庭安全健康中心，享受科技生活！";
    }
    
    [[Frontia getShare] showShareMenuWithShareContent:content
                        displayPlatforms:[NSArray arrayWithObjects:
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_SINAWEIBO,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_QQ,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_QQFRIEND,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_QQWEIBO,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_RENREN,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_SMS,
                                          FRONTIA_SOCIAL_SHARE_PLATFORM_EMAIL, nil]
                        supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait
                        isStatusBarHidden:NO targetViewForPad:nil
                        cancelListener:^{
#ifdef DEBUG
                            NSLog(@"[PORTAL VIEW] Share Cancelled.");
#endif
                        }
                        failureListener:^(int errorCode, NSString *errorMessage){
#ifdef DEBUG
                            NSLog(@"[PORTAL VIEW] Share failed, error code is %d error message is %@.", errorCode, errorMessage);
#endif
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"share_failed", @"") forType:AlertViewTypeFailed];
                                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
                            });
                        }
                        resultListener:^(NSDictionary *response) {
#ifdef DEBUG
                            NSLog(@"[PORTAL VIEW] Share success result is %@.", (response == nil || response.description == nil) ? @"" : response.description);
#endif
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"share_success", @"") forType:AlertViewTypeSuccess];
                                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
                            });
                        }];
}

- (void)setUp {
    [super setUp];
    
    BOOL hasLogin = ![[XXStringUtils emptyString] isEqualToString:[GlobalSettings defaultSettings].secretKey];
    if(hasLogin) {
        [[CoreService defaultService] startService];
    } else {
        UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        loginNavController.navigationBarHidden = YES;
        [self presentViewController:loginNavController animated:NO completion:^{ }];
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

//- (void)btnScenePressed:(id)sender {
//    XXActionSheet *actionSheet = [[XXActionSheet alloc] init];
//    actionSheet.title = NSLocalizedString(@"select_scene_mode", @"");
//
//    NSDictionary *templates = [ScenesTemplate defaultTemplates];
//    NSMutableArray *templateKeys = [NSMutableArray arrayWithCapacity:4];
//    [actionSheet addButtonWithTitle:[[templates dictionaryForKey:kSceneReturnHome] noNilStringForKey:kTemplateName]];
//    [templateKeys addObject:kSceneReturnHome];
//    [actionSheet addButtonWithTitle:[[templates dictionaryForKey:kSceneOut] noNilStringForKey:kTemplateName]];
//    [templateKeys addObject:kSceneOut];
//    [actionSheet addButtonWithTitle:[[templates dictionaryForKey:kSceneSleep] noNilStringForKey:kTemplateName]];
//    [templateKeys addObject:kSceneSleep];
//    [actionSheet addButtonWithTitle:[[templates dictionaryForKey:kSceneGetUp] noNilStringForKey:kTemplateName]];
//    [templateKeys addObject:kSceneGetUp];
//
//    [actionSheet setParameter:templateKeys forKey:@"templateKeys"];
//    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"")];
//    actionSheet.delegate = self;
//    [actionSheet showInView:self.view];
//}

- (void)resizeScrollView {
    [self resizeScrollViewWithFlag:0];
}

- (void)resizeScrollViewWithFlag:(int)flag {
    CGFloat totalHeight = 0.f;
    for(UIView *view in scrollView.subviews) {
        if([view isKindOfClass:[UIImageView class]] && view.tag != IMAGE_VIEW_TAG) {
            continue;
        }
        totalHeight += view.bounds.size.height;
        if(flag == 1) {
            if(view != aqiPanelView && view != imgHeathIndex) {
                view.center = CGPointMake(view.center.x, view.center.y + AQI_PANEL_VIEW_HEIGHT);
            }
        } else if(flag == 2) {
            if(view != aqiPanelView && view != imgHeathIndex) {
                view.center = CGPointMake(view.center.x, view.center.y - AQI_PANEL_VIEW_HEIGHT);
            }
        }
    }
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, totalHeight);
}

- (void)showUnitSelectionView:(id)sender {
    [[Shared shared].app.rootViewController showRightView];
}

//- (void)showSpeechViewController:(id)sender {
//    if(speechViewIsOpening) return;
//    if(self.parentViewController != nil) {
//        speechViewIsOpening = YES;
//        SpeechViewController *speechViewController = [[SpeechViewController alloc] init];
//        RootViewController *rootViewController = [Shared shared].app.rootViewController;
//        [rootViewController addChildViewController:speechViewController];
//        [self willMoveToParentViewController:nil];
//        CGRect frame = speechViewController.view.frame;
//        speechViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [rootViewController transitionFromViewController:self toViewController:speechViewController duration:0.8f options:UIViewAnimationOptionTransitionCrossDissolve
//            animations:^{
//            }
//            completion:^(BOOL finished) {
//                [speechViewController didMoveToParentViewController:rootViewController];
//                [self removeFromParentViewController];
//                [rootViewController setDisplayViewController:speechViewController];
//                speechViewIsOpening = NO;
//            }];
//    }
//}

- (void)btnRenameUnit:(id)sender {
    Unit *currentUnit = [UnitManager defaultManager].currentUnit;
    if(currentUnit != nil) {
        UnitDetailsViewController *unitDetailsViewController = [[UnitDetailsViewController alloc] initWithUnit:currentUnit];
        [self.navigationController pushViewController:unitDetailsViewController animated:YES];
    }
}

- (void)showNetworkStateView:(BOOL)reachbilityInternal {
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
    if(reachbilityInternal) {
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
        [self updateNetworkStateForView:evt.netMode];
    } else if([event isKindOfClass:[UnitsListUpdatedEvent class]]
              || [event isKindOfClass:[CurrentUnitChangedEvent class]]) {
        [self updateUnitsView];
    } else if([event isKindOfClass:[SensorStateChangedEvent class]]) {
        Unit *currentUnit = [UnitManager defaultManager].currentUnit;
        if(currentUnit != nil) {
            SensorStateChangedEvent *ssevt = (SensorStateChangedEvent *)event;
            if([ssevt.unitIdentifier isEqualToString:currentUnit.identifier]) {
                [self updateSensorsStatus:currentUnit];
            }
        }
    } else if([event isKindOfClass:[DeviceStatusChangedEvent class]]) {
        Unit *currentUnit = [UnitManager defaultManager].currentUnit;
        if(currentUnit != nil) {
            DeviceStatusChangedEvent *dsevt = (DeviceStatusChangedEvent *)event;
            if(dsevt.command != nil && ![XXStringUtils isBlank:dsevt.command.masterDeviceCode]) {
                if([dsevt.command.masterDeviceCode isEqualToString:currentUnit.identifier]) {
                    [self updateUnitStatus:currentUnit];
                }
            }
        }
    } else if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        if([evt.command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
            DeviceCommandUpdateAccount *cmd = (DeviceCommandUpdateAccount *)evt.command;
            LeftNavView *leftView = (LeftNavView *)[Shared shared].app.rootViewController.leftView;
            [leftView setScreenName:cmd.screenName];
        }
    } else if([event isKindOfClass:[CurrentLocationUpdatedEvent class]]) {
        CurrentLocationUpdatedEvent *evt = (CurrentLocationUpdatedEvent *)event;
        [self updateAQIPanelViewWithAqi:evt.aqiDetail];
    } else if([event isKindOfClass:[ScoreChangedEvent class]]) {
        ScoreChangedEvent *evt = (ScoreChangedEvent *)event;
        [self updateUnitScoreViewWithScore:evt.score];
    } else if([event isKindOfClass:[NotificationsFileUpdatedEvent class]]) {
#ifdef DEBUG
        NSLog(@"[Portal View] Received Notifications");
#endif
        [self mayShowNotificationsInView];
    }
}

#pragma mark -
#pragma mark Events notifications

// called when view will appear
// called when some events arrived (units list update event || current unit changed event)
- (void)updateUnitsView {
    Unit *currentUnit = [UnitManager defaultManager].currentUnit;
    
    self.topbarView.title = currentUnit != nil ? currentUnit.name : NSLocalizedString(@"app_name", @"");
    
    [self updateSensorsStatus:currentUnit];
    [self updateUnitStatus:currentUnit];
    [self updateUnitScoreViewWithScore:currentUnit.score];

    // current unit of 'unit selection view'
    // is managed by this controller
    // it's not like others which maintaince in event system
    [self updateUnitsSelectionView];
}

- (void)updateUnitStatus:(Unit *)unit {
    if(controlPanelView != nil) {
        [controlPanelView refreshWithUnit:unit];
    }
}

- (void)updateSensorsStatus:(Unit *)unit {
    if(sensorDisplayPanel != nil) {
        [sensorDisplayPanel setNoDataForSensorType:SensorTypeTempure];
        [sensorDisplayPanel setNoDataForSensorType:SensorTypeHumidity];
        [sensorDisplayPanel setNoDataForSensorType:SensorTypePM25];
        [sensorDisplayPanel setNoDataForSensorType:SensorTypeVOC];
        if(unit != nil && unit.sensors != nil) {
            for(int i=0; i<unit.sensors.count; i++) {
                Sensor *sensor = [unit.sensors objectAtIndex:i];
                if(sensor.isPM25Sensor) {
                    [sensorDisplayPanel setValue:sensor.data.value forSensorType:SensorTypePM25];
                } else if(sensor.isHumiditySensor) {
                    [sensorDisplayPanel setValue:sensor.data.value forSensorType:SensorTypeHumidity];
                } else if(sensor.isVOCSensor) {
                    [sensorDisplayPanel setValue:sensor.data.value forSensorType:SensorTypeVOC];
                } else if(sensor.isTempureSensor) {
                    [sensorDisplayPanel setValue:sensor.data.value forSensorType:SensorTypeTempure];
                }
            }
        }
    }
}

// BOOL means which that scroll view has or hasn't resized
- (BOOL)updateAQIPanelViewWithAqi:(AQIDetail *)aqiDetail {
    if(aqiPanelView == nil) {
        aqiPanelView = [[AQIPanelView alloc] initWithPoint:CGPointMake(0, imgHeathIndex.frame.origin.y + imgHeathIndex.bounds.size.height)];
    }
    if(aqiDetail != nil) {
        // view isn't already on screen
        // because aqi is not empty
        // so need to add this view
        [aqiPanelView setCity:aqiDetail.area dateComponets:aqiDetail.dateComponentsForUpdateTime aqiNumber:aqiDetail.aqiNumber aqiText:aqiDetail.quality tips:aqiDetail.tips level:1];
        if(aqiPanelView.superview == nil) {
            [scrollView insertSubview:aqiPanelView aboveSubview:sensorDisplayPanel];
            [self resizeScrollViewWithFlag:1];
            return YES;
        }
    } else {
        // view is already on screen
        // because aqi is nil
        // so need to remove this view
        if(aqiPanelView.superview != nil) {
            [aqiPanelView removeFromSuperview];
            [self resizeScrollViewWithFlag:2];
            return YES;
        }
    }
    return NO;
}

- (void)updateUnitScoreViewWithScore:(Score *)score {
    if(score == nil || score.score == -1) {
        lblHealthIndex.text = @"--";
//        lblHealthIndexGreatThan.text = @" --%";
//        lblEvaluateTime.text = NSLocalizedString(@"has_not_refresh", @"");
    } else {
        if(score.score == 100) {
           lblHealthIndex.font = [UIFont systemFontOfSize:38];
           lblHealthIndex.text = [NSString stringWithFormat:@"%d", score.score];
        } else {
           lblHealthIndex.font = [UIFont systemFontOfSize:50];
           lblHealthIndex.text = [NSString stringWithFormat:@"%d", score.score];
        }
//        if(score.rankings != -1) {
//            lblHealthIndexGreatThan.text = [NSString stringWithFormat:@"%d%%", score.rankings];
//        } else {
//            lblHealthIndexGreatThan.text = @" --%";
//        }
//        lblEvaluateTime.text = score.scoreDate == nil ? NSLocalizedString(@"has_not_refresh", @"") : [score scoreDateAsFormattedString];
    }
}

- (void)updateUnitsSelectionView {
    RootViewController *rootViewController = [Shared shared].app.rootViewController;
    if(rootViewController.rightView != nil) {
        UnitSelectionDrawerView *unitSelectionView = (UnitSelectionDrawerView *)rootViewController.rightView;
        [unitSelectionView refresh];
    }
}

- (void)updateNetworkStateForView:(NetMode)netMode {
    if((netMode & NetModeExtranet) == NetModeExtranet) {
        [self hideNetworkStateView];
    } else {
        [self showNetworkStateView:(netMode & NetModeInternal) == NetModeInternal];
    }
}

- (void)mayShowNotificationsInView {
//    NSArray *notifications = [[NotificationsFileManager fileManager] readFromDisk];
//    if(notifications != nil) {
//        for(SMNotification *notification in notifications) {
//        
//        }
//    }
}

- (void)reset {
    getAccountCommandHasSent = NO;
}

@end
