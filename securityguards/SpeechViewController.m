//
//  SpeechViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechViewController.h"
#import "ConversationTextMessage.h"
#import "XXDateFormatter.h"
#import "SpeechStateView.h"
#import "DeviceCommandNameEventFilter.h"
#import "XXEventNameFilter.h"
#import "XXEventFilterChain.h"
#import "DeviceStatusChangedEvent.h"
#import "DeviceCommandEvent.h"
#import "Shared.h"
#import "UnitManager.h"

#define MESSAGE_VIEW_TAG 999

typedef NS_ENUM(NSInteger, RecognizerState) {
    RecognizerStateReady,
    RecognizerStatePrepareRecord,
    RecognizerStateRecording,
    RecognizerStateRecordingEnd,
    RecognizerStateProcessing
};

@interface SpeechViewController ()

@end

@implementation SpeechViewController {
    UITableView *tblMessages;
    NSMutableArray *_messages_;
    
    SpeechRecognitionUtil *speechRecognitionUtil;
    RecognizerState recognizerState;
    
    BOOL portalViewIsOpenning;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if(self) {
        _messages_ = [NSMutableArray array];
    }
    return self;
}

- (id)initWithMessages:(NSArray *)messages {
    self = [super init];
    if(self) {
        if(messages != nil) {
            _messages_ = [NSMutableArray arrayWithArray:messages];
        } else {
            _messages_ = [NSMutableArray array];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[Shared shared].app.rootViewController disableGestureForDrawerView];
    
    DeviceCommandNameEventFilter *commandNameFilter = [[DeviceCommandNameEventFilter alloc] init];
    [commandNameFilter.supportedCommandNames addObject:COMMAND_VOICE_CONTROL];
    XXEventNameFilter *eventNameFilter = [[XXEventNameFilter alloc] initWithSupportedEventNames:[NSArray arrayWithObjects:EventDeviceStatusChanged, nil]];
    XXEventFilterChain *filterChain = [[XXEventFilterChain alloc] init];
    [[filterChain orFilter:commandNameFilter] orFilter:eventNameFilter];
    
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filterChain];
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[Shared shared].app.rootViewController enableGestureForDrawerView];
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)viewDidAppear:(BOOL)animated {
    if(_messages_.count > 0) return;
    ConversationTextMessage *msg = [[ConversationTextMessage alloc] init];
    msg.textMessage = NSLocalizedString(@"speech_tips", @"");
    msg.messageOwner = MESSAGE_OWNER_THEIRS;
    msg.timeMessage = [XXDateFormatter dateToString:[NSDate date] format:@"MM-dd HH:mm:ss"];
    [self addMessage:msg];
}

- (void)initDefaults {
    [super initDefaults];
    portalViewIsOpenning = NO;
    recognizerState = RecognizerStateReady;
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"speech_view_title", @"");
    self.view.backgroundColor = [UIColor appGray];
    
    /*
     * Create voice button view
     */
    UIView *voiceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 42, [UIScreen mainScreen].bounds.size.width, 42)];
    voiceBackgroundView.backgroundColor = [UIColor appGray];
    
    UIButton *btnVoice = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 556 / 2, 64 / 2)];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_gray"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"btn_voice_blue"] forState:UIControlStateHighlighted];
    [btnVoice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnVoice setTitle:NSLocalizedString(@"press_begin_speaking", @"") forState:UIControlStateNormal];
    [btnVoice setTitle:NSLocalizedString(@"release_end_speaking", @"") forState:UIControlStateHighlighted];
    btnVoice.center = CGPointMake(voiceBackgroundView.center.x, btnVoice.center.y);
    
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [voiceBackgroundView addSubview:btnVoice];
    [self.view addSubview:voiceBackgroundView];
    
    tblMessages = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height + 10, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - voiceBackgroundView.bounds.size.height - 10) style:UITableViewStylePlain];
    tblMessages.delegate = self;
    tblMessages.dataSource = self;
    tblMessages.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblMessages.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tblMessages];
}

- (void)setUp {
}

- (void)addMessage:(ConversationMessage *)message {
    if(message == nil) return;
    [_messages_ addObject:message];
    [tblMessages beginUpdates];
    NSIndexPath *newMessageIndexPath = [NSIndexPath indexPathForRow:(_messages_.count - 1) inSection:0];
    [tblMessages insertRowsAtIndexPaths:[NSArray arrayWithObject:newMessageIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [tblMessages endUpdates];
    [tblMessages scrollToRowAtIndexPath:newMessageIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)clearAllMessages {
    if(_messages_ == nil || _messages_.count == 0) return;
    [_messages_ removeAllObjects];
    [tblMessages reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages_ == nil ? 0 : _messages_.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationMessage *message = [_messages_ objectAtIndex:indexPath.row];
    if(message != nil) {
        UIView *messageView = [message viewWithMessage:self.view.bounds.size.width];
        if(messageView != nil) {
            return messageView.frame.size.height + 10;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    UIView *msgView = [cell viewWithTag:MESSAGE_VIEW_TAG];
    if(msgView != nil) {
        [msgView removeFromSuperview];
        msgView = nil;
    }
    
    ConversationMessage *msg = [_messages_ objectAtIndex:indexPath.row];
    msgView = [msg viewWithMessage:self.view.bounds.size.width];
    if(msgView != nil) {
        msgView.tag = MESSAGE_VIEW_TAG;
        [cell addSubview:msgView];
    }
    return cell;
}

#pragma mark -
#pragma mark Speech Recognizer

- (void)resetRecognizer {
    recognizerState = RecognizerStateReady;
}

- (void)btnSpeechTouchDown:(id)sender {
    if(recognizerState == RecognizerStateReady) {
        recognizerState = RecognizerStatePrepareRecord;
        [self startListening:nil];
    }
}

- (void)btnSpeechTouchUpInside:(id)sender {
    [SpeechStateView defaultView].state = SpeechViewStateNone;
    [speechRecognitionUtil stopListening];
}

- (void)btnSpeechTouchUpOutside:(id)sender {
    [SpeechStateView defaultView].state = SpeechViewStateNone;
    [speechRecognitionUtil cancel];
}

- (void)btnSpeechTouchDragExit:(id)sender {
    //touch down and dragg out of button
    [SpeechStateView defaultView].state = SpeechViewStateWillCancel;
}

- (void)btnSpeechTouchDragEnter:(id)sender {
    //touch down and dragg enter button when previous status is out of button
    [SpeechStateView defaultView].state = SpeechViewStateSpeaking;
}

- (void)startListening:(NSTimer *)timer {
    if(speechRecognitionUtil == nil) {
        speechRecognitionUtil = [SpeechRecognitionUtil current];
    }
    speechRecognitionUtil.speechRecognitionNotificationDelegate = self;
    if(![speechRecognitionUtil startListening]) {
#ifdef DEBUG
        NSLog(@"[SPEECH RECOGNIZER] Start listening failed.");
#endif
    }
}

#pragma mark -
#pragma mark speech recognizer notification delegate

- (void)beginRecord {
    recognizerState = RecognizerStateRecording;
    [SpeechStateView defaultView].state = SpeechViewStateSpeaking;
}

- (void)endRecord {
    recognizerState = RecognizerStateRecordingEnd;
    [SpeechStateView defaultView].state = SpeechViewStateNone;
}

- (void)recognizeCancelled {
    [self speechRecognizerFailed:@"[SPEECH RECOGNIZER] Cancelled by user."];
}

- (void)speakerVolumeChanged:(int)volume {
    if(recognizerState == RecognizerStateRecording) {
        //        int v = volume / 3;
        //        if(v > 9) v = 9;
        //        if(v < 0) v = 0;
        //        [btnSpeech setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_speech_0%d.png", v]] forState:UIControlStateNormal];
    }
}

- (void)recognizeSuccess:(NSString *)result {
    if(![XXStringUtils isBlank:result]) {
        //Process text message
#ifdef DEBUG
        NSLog(@"[SPEECH RECOGNIZER] Send voice command [%@].", result);
#endif
        ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
        textMessage.messageOwner = MESSAGE_OWNER_MINE;
        textMessage.textMessage = result;
        textMessage.timeMessage = [XXDateFormatter dateToString:[NSDate date] format:@"HH:mm:ss"];
        [self addMessage:textMessage];
        
        DeviceCommandVoiceControl *command = (DeviceCommandVoiceControl *)[CommandFactory commandForType:CommandTypeUpdateDeviceViaVoice];
        command.masterDeviceCode = [UnitManager defaultManager].currentUnit.identifier;
        command.voiceText = result;
        [[CoreService defaultService] executeDeviceCommand:command];
    } else {
        [self speechRecognizerFailed:@"[SPEECH RECOGNIZER] No speaking"];
    }
    [self resetRecognizer];
}

- (void)recognizeError:(int)errorCode {
    [self speechRecognizerFailed:[NSString stringWithFormat:@"[SPEECH RECOGNIZER] Error, the code is %d", errorCode]];
    [self resetRecognizer];
}

- (void)speechRecognizerFailed:(NSString *)message {
#ifdef DEBUG
    NSLog(@"[SPEECH RECOGNIZER] Recognize failed, reason is [ %@ ]", message);
#endif
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        DeviceCommandVoiceControl *cmd = (DeviceCommandVoiceControl *)evt.command;
        [self notifyVoiceControlAccept:cmd];
    } else if([event isKindOfClass:[DeviceStatusChangedEvent class]]) {
        DeviceStatusChangedEvent *evt = (DeviceStatusChangedEvent *)event;
        [self notifyDeviceStatusChanged:evt.command];
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"speechViewControllerSubscriber";
}

- (void)notifyDeviceStatusChanged:(DeviceCommandUpdateDevices *)command {
    if([XXStringUtils isBlank:command.voiceText]) return;
    
    NSString *successMsg = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"execution_success", @"")] ;
    NSString *successErr = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"execution_failed", @"")] ;
    NSString *executeResult = (command.resultID == 1) ? successMsg : successErr;
    
    ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
    textMessage.messageOwner = MESSAGE_OWNER_THEIRS;
    textMessage.textMessage = [NSString stringWithFormat:@"%@ %@", command.voiceText, executeResult];
    textMessage.timeMessage = [XXDateFormatter dateToString:[NSDate date] format:@"HH:mm:ss"];
    [self addMessage:textMessage];
}

- (void)notifyVoiceControlAccept:(DeviceCommandVoiceControl *)command {
    if(command == nil) return;
    if(command.resultID != 1) {
        ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
        textMessage.messageOwner = MESSAGE_OWNER_THEIRS;
        textMessage.textMessage = command.describe;
        textMessage.timeMessage = [XXDateFormatter dateToString:[NSDate date] format:@"HH:mm:ss"];
        [self addMessage:textMessage];
    }
}

- (void)popupViewController {
    if(portalViewIsOpenning) return;
    if(self.parentViewController != nil) {
        portalViewIsOpenning = YES;
        RootViewController *rootViewController = [Shared shared].app.rootViewController;
        UIViewController *toViewController = rootViewController.portalViewController;
        [self willMoveToParentViewController:nil];
        [rootViewController addChildViewController:toViewController];
        [rootViewController transitionFromViewController:self toViewController:toViewController duration:0.8f options:UIViewAnimationOptionTransitionCrossDissolve
            animations:^{
            }
            completion:^(BOOL finished){
                [toViewController didMoveToParentViewController:rootViewController];
                [self removeFromParentViewController];
                [rootViewController setDisplayViewController:toViewController];
                portalViewIsOpenning = NO;
            }];
    }
}

@end
