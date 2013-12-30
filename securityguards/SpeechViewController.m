//
//  SpeechViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechViewController.h"
#import "RootViewController.h"
#import "ConversationTextMessage.h"
#import "UIColor+MoreColor.h"

#define MESSAGE_VIEW_TAG 999

@interface SpeechViewController ()

@end

@implementation SpeechViewController {
    UITableView *tblMessages;
    NSMutableArray *_messages_;
    
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
        
        ConversationTextMessage *msg = [[ConversationTextMessage alloc] init];
        msg.textMessage = @"你好， 你是一个猪";
        msg.messageOwner = MESSAGE_OWNER_MINE;
        msg.timeMessage = @"2012-12-12";
        
        [_messages_ addObject:msg];
        
        ConversationTextMessage *msg1 = [[ConversationTextMessage alloc] init];
        msg1.textMessage = @"你好， 你是一个猪fj就度搜IF奖度搜ifdfsji发生较低偶发束带结发 收到就覅";
        msg1.messageOwner = MESSAGE_OWNER_THEIRS;
        msg1.timeMessage = @"2012-12-12";
        
        [_messages_ addObject:msg1];
        
        ConversationTextMessage *msg2 = [[ConversationTextMessage alloc] init];
        msg2.textMessage = @"你好， 你是上地附近第四季覅 度搜积分 第三方记下来呢接任务无金额猪打了他";
        msg2.messageOwner = MESSAGE_OWNER_MINE;
        msg2.timeMessage = @"2012-12-12";
        
        [_messages_ addObject:msg2];
        
        ConversationTextMessage *msg3 = [[ConversationTextMessage alloc] init];
        msg3.textMessage = @"你好， 电视机佛收到就猪";
        msg3.messageOwner = MESSAGE_OWNER_THEIRS;
        msg3.timeMessage = @"2012-12-12";
        
        [_messages_ addObject:msg3];
        
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
    RootViewController *rootViewController = (RootViewController *)self.parentViewController;
    [rootViewController disableGestureForDrawerView];
}

- (void)viewWillDisappear:(BOOL)animated {
    RootViewController *rootViewController = (RootViewController *)self.parentViewController;
    [rootViewController enableGestureForDrawerView];
}

- (void)initDefaults {
    [super initDefaults];
    
    portalViewIsOpenning = NO;
}

- (void)initUI {
    [super initUI];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.7f;
    self.topbarView.title = @"speech test";
    
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
    
    /*
     
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [btnVoice addTarget:self action:@selector(btnSpeechTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
     
     */
    
    [voiceBackgroundView addSubview:btnVoice];
    [self.view addSubview:voiceBackgroundView];
    
    tblMessages = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height + 5, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - voiceBackgroundView.bounds.size.height - 5) style:UITableViewStylePlain];
    tblMessages.delegate = self;
    tblMessages.dataSource = self;
    tblMessages.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblMessages.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tblMessages];
    
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
    }

    UIView *msgView = [cell viewWithTag:MESSAGE_VIEW_TAG];
    if(msgView != nil) {
        [msgView removeFromSuperview];
        msgView = nil;
    }
    
    ConversationMessage *msg = [_messages_ objectAtIndex:indexPath.row];
    msgView = [msg viewWithMessage:self.view.bounds.size.width];
    if(msgView != nil) {
        [cell addSubview:msgView];
    }
    return cell;
}

- (void)popupViewController {
    if(portalViewIsOpenning) return;
    if(self.parentViewController != nil) {
        portalViewIsOpenning = YES;
        RootViewController *rootViewController = (RootViewController *)self.parentViewController;
        UIViewController *toViewController = rootViewController.portalViewController.parentViewController;
        [self willMoveToParentViewController:nil];
        [rootViewController addChildViewController:toViewController];
        [rootViewController transitionFromViewController:self toViewController:toViewController duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve
            animations:^{}
            completion:^(BOOL finished){
                [toViewController didMoveToParentViewController:rootViewController];
                [self removeFromParentViewController];
                [rootViewController setDisplayViewController:toViewController];
                portalViewIsOpenning = NO;
            }];
    }
}

@end
