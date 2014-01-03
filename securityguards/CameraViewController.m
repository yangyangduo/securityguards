//
//  CameraViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraViewController.h"
//#import "CameraLoadingView.h"
//#import "VideoConverter.h"
#import "CameraService.h"
#import "SystemAudio.h"
#import "DeviceCommandNameEventFilter.h"
#import "XXEventSubscriptionPublisher.h"

#define TWO_TIMES_CLICK_INTERVAL 500
#define RECORDING_BUFFER_LIST_LENGTH 9

@interface CameraViewController ()

@end

@implementation CameraViewController{
    UIImageView *imgCameraShots;
    
    BOOL firstImageHasBeenSet;
    DirectionButton *btnDirection;
    CameraSocket *socket;
    CameraService *cameraService;
    double lastedClickTime;
    UIButton *btnCatchScreen;
    
    BOOL cameraIsRunning;
    
    /*  for screen shots */
    BOOL isCapture;
}

@synthesize cameraDevice;

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

//- (void)viewWillAppear:(BOOL)animated {
//    DeviceCommandNameEventFilter *filter = [[DeviceCommandNameEventFilter alloc] init];
//    [filter.supportedCommandNames addObject:COMMAND_GET_CAMERA_SERVER];
//    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filter];
//    subscription.notifyMustInMainThread = YES;
//    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
//    
//    [self startMonitorCamera];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
//}

#pragma mark -
#pragma mark Initializations

- (void)initDefaults {
    [super initDefaults];
    
    cameraIsRunning = NO;
    isCapture = NO;
}

- (void)initUI {
    [super initUI];
    
    imgCameraShots = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240)];
    imgCameraShots.backgroundColor = [UIColor colorWithRed:102.f / 255.f green:102.f / 255.f blue:102.f / 255.f alpha:1.0f];
    [self.view addSubview:imgCameraShots];
    
//    if (btnCatchScreen == nil) {
//        btnCatchScreen = [[UIButton alloc] initWithFrame:CGRectMake(266, backgroundView.frame.origin.y+15, 44, 44)];
//        [btnCatchScreen setBackgroundImage:[UIImage imageNamed:@"btn_catch_screen.png"] forState:UIControlStateNormal];
//        [btnCatchScreen addTarget:self action:@selector(catchScreen) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btnCatchScreen];
//    }
//    
//    
//    
//    if(btnDirection == nil) {
//        btnDirection = [DirectionButton cameraDirectionButtonWithPoint:CGPointMake(90, imgCameraShots.frame.origin.y + imgCameraShots.bounds.size.height + 20)];
//        btnDirection.delegate = self;
//        [self.view addSubview:btnDirection];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popupViewController {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self stopMonitorCamera];
    });
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
    DeviceCommandReceivedCameraServer *cmd = (DeviceCommandReceivedCameraServer *)evt.command;
    [self receivedCameraServer:cmd];
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"cameraViewControllerSubscriber";
}

#pragma mark -
#pragma mark Open && Stop Camera

- (void)startMonitorCamera {
    if(self.cameraDevice == nil) return;
    DeviceCommandGetCameraServer *cmd = (DeviceCommandGetCameraServer *)[CommandFactory commandForType:CommandTypeGetCameraServer];
    cmd.masterDeviceCode = self.cameraDevice.zone.unit.identifier;
    cmd.cameraId = self.cameraDevice.identifier;
//    [[SMShared current].deliveryService executeDeviceCommand:cmd];
}

- (void)stopMonitorCamera {
    cameraIsRunning = NO;
    
    if(socket != nil && [socket isConnectted]) {
        [socket closeGraceful];
    }
    
    if(cameraService != nil && [cameraService isPlaying]) {
        [cameraService dontNotifyMe];
        [cameraService close];
        cameraService = nil;
    }
}

#pragma mark -
#pragma mark Device command get camera server delegate

- (void)receivedCameraServer:(DeviceCommandReceivedCameraServer *)command {
    if(self.cameraDevice == nil) return;
    if(![self.cameraDevice.identifier isEqualToString:command.cameraId]) return;
    
    if(command.commmandNetworkMode == CommandNetworkModeInternal) {
        if(cameraService != nil && [cameraService isPlaying]) {
            [cameraService close];
            cameraService.delegate = nil;
            cameraService = nil;
        }
        NSString *cameraUrl = [NSString stringWithFormat:@"http://%@:%d/snapshot.cgi?user=%@&pwd=%@", self.cameraDevice.ip, self.cameraDevice.port, self.cameraDevice.user, self.cameraDevice.pwd];
        cameraService = [[CameraService alloc] initWithUrl:cameraUrl];
        cameraService.delegate = self;
        [cameraService open];
    } else {
        NSArray *addressSet = [command.server componentsSeparatedByString:@":"];
        if(addressSet != nil && addressSet.count == 2) {
            NSString *address = [addressSet objectAtIndex:0];
            NSString *port = [addressSet objectAtIndex:1];
            if(socket != nil && [socket isConnectted]) {
                [socket close];
            }
            socket = [[CameraSocket alloc] initWithIPAddress:address andPort:port.integerValue];
            socket.delegate = self;
            socket.key = command.conStr;
            if(socket != nil) {
                [self performSelectorInBackground:@selector(openCameraSocketInBackground) withObject:nil];
            }
        }
    }
}

- (void)openCameraSocketInBackground {
    [socket connect];
}

#pragma mark -
#pragma mark Camera socket delegate

///* Called by main thread */
//- (void)notifyNewImageWasReceived:(UIImage *)image {
//    if(!firstImageHasBeenSet) {
//        CameraLoadingView * loadingView = (CameraLoadingView *)[imgCameraShots viewWithTag:9999];
//        if(loadingView != nil) {
//            [loadingView hide];
//        }
//    }
//    imgCameraShots.image = image;
//    
//    //    if(isRecoding) {
//    //        [self recodingWithImage:image];
//    //    }
//}
//
//- (void)notifyCameraConnectted {
//    firstImageHasBeenSet = NO;
//    cameraIsRunning = YES;
//}
//
//- (void)notifyCameraWasDisconnectted {
//    imgCameraShots.image = nil;
//    firstImageHasBeenSet = NO;
//    CameraLoadingView * loadingView = (CameraLoadingView *)[imgCameraShots viewWithTag:9999];
//    if(loadingView != nil) {
//        [loadingView showError];
//    }
//#ifdef DEBUG
//    NSLog(@"[CAMERA] Closed.");
//#endif
//}

#pragma mark -
#pragma mark Screen shots

- (void)catchScreen {
    if(isCapture) return;
    
    if(cameraIsRunning) {
        if(imgCameraShots != nil && imgCameraShots.image != nil) {
            isCapture = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(imgCameraShots.image, nil, nil, nil);
                [SystemAudio photoShutter];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"catch_screen_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] alert:YES isLock:NO];
                    isCapture = NO;
                });
            });
        }
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"camera_is_not_running", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] alert:YES isLock:NO];
        return;
    }
}

#pragma mark -
#pragma mark Direction button delegate

- (void)leftButtonClicked {
    [self adjustCamera:@"2"];
}

- (void)rightButtonClicked {
    [self adjustCamera:@"3"];
}

- (void)topButtonClicked {
    [self adjustCamera:@"0"];
}

- (void)bottomButtonClicked {
    [self adjustCamera:@"1"];
}

- (void)adjustCamera:(NSString *)direction {
    if(self.cameraDevice == nil) return;
    
    // Check btn click is too often
    double now = [NSDate date].timeIntervalSince1970 * 1000;
    if(lastedClickTime != -1) {
        if(now - lastedClickTime <= TWO_TIMES_CLICK_INTERVAL) {
            lastedClickTime = now;
            return;
        }
    }
    lastedClickTime = now;
    
    DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    updateDeviceCommand.masterDeviceCode = self.cameraDevice.zone.unit.identifier;
    [updateDeviceCommand addCommandString:[self.cameraDevice commandStringForCamera:direction]];
//    [[SMShared current].deliveryService executeDeviceCommand:updateDeviceCommand
//     ];
}

@end
