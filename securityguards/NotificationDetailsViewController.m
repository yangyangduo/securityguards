//
//  NotificationDetailsViewController.m
//  securityguards
//
//  Created by hadoop user account on 31/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationDetailsViewController.h"
#import "MessageCell.h"
#import "XXDateFormatter.h"
#import "BlueButton.h"
#import "NotificationsFileManager.h"
#import "PlayCameraPicViewController.h"

@interface NotificationDetailsViewController ()

@end

@implementation NotificationDetailsViewController
@synthesize notification = _notification_;
@synthesize delegate;

- (id)initWithNotification:(SMNotification *)notification {
    self = [super init];
    if (self) {
        _notification_ = notification;
    }
    return self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
}

- (void)initUI {
    [super initUI];
    
    if(self.notification == nil) return;
    
    self.topbarView.title = self.notification.typeName;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height+5,self.view.frame.size.width-10 , MESSAGE_CELL_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    view.center = CGPointMake(self.view.center.x, view.center.y);
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    view.layer.cornerRadius = 5;
    
    UIImageView *typeMessage = typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50/2, 39/2)];
    if([self.notification.type isEqualToString:@"MS"] || [self.notification.type isEqualToString:@"AT"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    } else if([self.notification.type isEqualToString:@"CF"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    } else if([self.notification.type isEqualToString:@"AL"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_warning"];
    }
    typeMessage.backgroundColor = [UIColor clearColor];
    typeMessage.tag = TYPE_IMAGE_TAG;
    [view addSubview:typeMessage];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240,MESSAGE_CELL_HEIGHT)];
    textLabel.tag = TEXT_LABEL_TAG;
    UIFont *font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.font = font;
    textLabel.text = [@"    " stringByAppendingString:self.notification.text];
    textLabel.textColor = [UIColor blackColor];
    textLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(240, 20000.0f);
    CGSize size = [textLabel.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    textLabel.frame = CGRectMake(40, 5, size.width, size.height<MESSAGE_CELL_HEIGHT?MESSAGE_CELL_HEIGHT:size.height*2);
    textLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:textLabel];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(40, textLabel.frame.size.height+5+2, 240, 15)];
    lblTime.text = [XXDateFormatter dateToString:self.notification.createTime format:@"yyyy-MM-dd HH:mm:ss"];
    lblTime.backgroundColor = [UIColor clearColor];
    lblTime.textColor = [UIColor blackColor];
    lblTime.font = [UIFont systemFontOfSize:12];
    [view addSubview:lblTime];
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, textLabel.frame.size.height+15+5+8);
    view.tag = CELL_VIEW_TAG;
    [self.view addSubview:view];
    if(self.notification.isWarning && self.notification.data.isCameraData) {
        BlueButton *btnCheck = [BlueButton blueButtonWithPoint:CGPointMake(5, view.frame.size.height+view.frame.origin.y+5) resize:CGSizeMake(152.5,98/2)];
        [btnCheck setTitle:NSLocalizedString(@"view_video", @"") forState:UIControlStateNormal];
        [self.view addSubview:btnCheck];
        BlueButton *btnDelete = [BlueButton blueButtonWithPoint:CGPointMake(162.5, btnCheck.frame.origin.y) resize:CGSizeMake(152.5,BLUE_BUTTON_DEFAULT_HEIGHT)];
        [btnDelete setTitle:NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
    } else if([self.notification.type isEqualToString:@"MS"] || [self.notification.type isEqualToString:@"AT"] || [self.notification.type isEqualToString:@"AL"]) {
        BlueButton *btnDelete = [BlueButton blueButtonWithPoint:CGPointMake(0,view.frame.size.height+view.frame.origin.y+5) resize:CGSizeMake(311,BLUE_BUTTON_DEFAULT_HEIGHT)];
        btnDelete.center = CGPointMake(self.view.center.x, btnDelete.center.y);
        [btnDelete setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
    } else if ([self.notification.type isEqualToString:@"CF"]) {
        BlueButton *btnAgree = [BlueButton blueButtonWithPoint:CGPointMake(5,view.frame.size.height+view.frame.origin.y+5) resize:CGSizeMake(100, BLUE_BUTTON_DEFAULT_HEIGHT)];
        [btnAgree setTitle: NSLocalizedString(@"agree", @"") forState:UIControlStateNormal];
        btnAgree.identifier = @"btnAgree";
        [self.view addSubview:btnAgree];
        [btnAgree addTarget:self action:@selector(btnAgreeOrRefusePressed:) forControlEvents:UIControlEventTouchUpInside];
        BlueButton *btnRefuse = [BlueButton blueButtonWithPoint:CGPointMake(0, 0) resize:CGSizeMake(100, BLUE_BUTTON_DEFAULT_HEIGHT)];
        btnRefuse.identifier = @"btnRefuse";
        btnRefuse.center = CGPointMake(btnAgree.center.x+btnAgree.frame.size.width+5, btnAgree.center.y);
        [btnRefuse setTitle: NSLocalizedString(@"refuse", @"") forState:UIControlStateNormal];
                [self.view addSubview:btnRefuse];
        [btnRefuse addTarget:self action:@selector(btnAgreeOrRefusePressed:) forControlEvents:UIControlEventTouchUpInside];
        if(self.notification.hasProcess) {
            btnAgree.enabled = NO;
            btnRefuse.enabled = NO;
        }
        BlueButton *btnDelete = [BlueButton blueButtonWithPoint:CGPointMake(0, 0) resize:CGSizeMake(100, BLUE_BUTTON_DEFAULT_HEIGHT)];
        btnDelete.center = CGPointMake(btnRefuse.center.x+btnRefuse.frame.size.width+5, btnRefuse.center.y);
        [btnDelete setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
    }
}

- (void)setUp {
    self.notification.hasRead = YES;
    [[NotificationsFileManager fileManager] update:[NSArray arrayWithObject:self.notification] deleteList:nil];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(smNotificationsWasUpdated)]) {
        [self.delegate smNotificationsWasUpdated];
    }
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnCheckPressed:(UIButton *)sender {
    PlayCameraPicViewController *playCameraPicViewController = [[PlayCameraPicViewController alloc] init];
    playCameraPicViewController.data = self.notification.data;
    [self presentViewController:playCameraPicViewController animated:YES completion:nil];
}

- (void)deleteBtnPressed:(UIButton *)sender {
    [[NotificationsFileManager fileManager] update:nil deleteList:[NSArray arrayWithObject:self.notification]];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delete_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(smNotificationsWasUpdated)]) {
            [self.delegate smNotificationsWasUpdated];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnAgreeOrRefusePressed:(XXButton *)btn {
    NSString *alertString = [XXStringUtils emptyString];
    if([@"btnAgree" isEqualToString:btn.identifier]) {
        self.notification.text = [self.notification.text stringByAppendingString:[NSString stringWithFormat:@" [%@] ", NSLocalizedString(@"agree", @"")]];
        alertString = [NSString stringWithFormat:@"已%@", NSLocalizedString(@"agree", @"")];
        [self sendBindingResult:YES];
    } else if([@"btnRefuse" isEqualToString:btn.identifier]) {
        self.notification.text = [self.notification.text stringByAppendingString:[NSString stringWithFormat:@" [%@] ", NSLocalizedString(@"refuse", @"")]];
        alertString = [NSString stringWithFormat:@"已%@", NSLocalizedString(@"refuse", @"")];
        [self sendBindingResult:NO];
    }
    self.notification.hasProcess = YES;
    [[NotificationsFileManager fileManager] update:[NSArray arrayWithObject:self.notification] deleteList:nil];
    [[AlertView currentAlertView] setMessage:alertString forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(smNotificationsWasUpdated)]) {
            [self.delegate smNotificationsWasUpdated];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBindingResult:(BOOL)agree {
    DeviceCommandAuthBinding *authBindingCommand = (DeviceCommandAuthBinding *)[CommandFactory commandForType:CommandTypeAuthBindingUnit];
    authBindingCommand.resultID = agree ? 1 : 2;
    authBindingCommand.masterDeviceCode = self.notification.data.masterDeviceCode;
    authBindingCommand.requestDeviceCode = self.notification.data.requestDeviceCode;
    [[CoreService defaultService].tcpService executeCommand:authBindingCommand];
}

@end
