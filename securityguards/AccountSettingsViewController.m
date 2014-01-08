//
//  AccountSettingsViewController.m
//  SmartHome
//
//  Created by hadoop user account on 2/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountSettingsViewController.h"
//#import "VerificationCodeSendViewController.h"

#import "CommandFactory.h"
#import "DeviceCommandUpdateAccount.h"

#import "XXEventSubscriptionPublisher.h"
#import "DeviceCommandNameEventFilter.h"

@interface Profile : NSObject

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *oldPassword;

@end

@implementation Profile

@synthesize nickName;
@synthesize mail;
@synthesize oldPassword;
@synthesize password;

@end


@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController {
    Profile *profile;
    BOOL profileChanged;
    BOOL once;
    
    UIButton *btnSubmit;
    UITableView *tblAccountSettings;
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
    [super initDefaults];
    once = YES;
    profileChanged = NO;
    profile = [[Profile alloc] init];
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"profile_title", @"");
    self.view.backgroundColor = [UIColor appGray];
    
    tblAccountSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    tblAccountSettings.delegate = self;
    tblAccountSettings.dataSource = self;
    tblAccountSettings.backgroundView = nil;
    tblAccountSettings.backgroundColor = [UIColor clearColor];
    tblAccountSettings.sectionHeaderHeight = 0;
    tblAccountSettings.sectionFooterHeight = 0;
    tblAccountSettings.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    [self.view addSubview:tblAccountSettings];
}

- (void)viewWillAppear:(BOOL)animated {
    DeviceCommandNameEventFilter *commandNameFilter = [[DeviceCommandNameEventFilter alloc] init];
    [commandNameFilter.supportedCommandNames addObject:COMMAND_GET_ACCOUNT];
    [commandNameFilter.supportedCommandNames addObject:COMMAND_UPDATE_ACCOUNT];
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:commandNameFilter];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    
    if(once) {
        once = NO;
        [[CoreService defaultService] executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        if([evt.command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
            DeviceCommandUpdateAccount *cmd = (DeviceCommandUpdateAccount *)evt.command;
            profile.nickName = cmd.screenName;
            profile.mail = cmd.email;
            [tblAccountSettings reloadData];
        } else {
            [self updateAccountOnComplete:evt.command];
        }
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"accountSettingsViewControllerSubscriber";
}

- (void)notifyMainViewScreenNameChanged {
//    NavigationView *nav = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"portalView"];
//    if(nav != nil) {
//        DrawerView *drawerView = (DrawerView *)nav.ownerController.leftView;
//        if(drawerView != nil) {
//            [drawerView setScreenName:[infoDictionary objectForKey:NSLocalizedString(@"nick_name", @"")]];
//        }
//    }
}

//- (void)updateUsername:(NSString *)username{
//    UITableViewCell *usernameCell = [infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    usernameCell.detailTextLabel.text = username;
//}

#pragma mark -
#pragma mark UI Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return 50;
    } else if(section == 1) {
        return 130;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = nil;
    if(section == 0) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 29)];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.textColor = [UIColor lightGrayColor];
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.text = NSLocalizedString(@"modify_account_tips", @"");
        [footView addSubview:lblDescription];
    } if(section == 1) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 58)];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.textColor = [UIColor lightGrayColor];
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.numberOfLines = 2;
        lblDescription.text = NSLocalizedString(@"modify_profile_tips", @"");
        [footView addSubview:lblDescription];
        if(btnSubmit == nil) {
            btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, 400 / 2, 53 / 2)];
            btnSubmit.center = CGPointMake(footView.center.x, btnSubmit.center.y);
            [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
            [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
            [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
            [btnSubmit setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
            [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
            btnSubmit.enabled = profileChanged;
        }
        [footView addSubview:btnSubmit];
    }
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor appDarkGray];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:17.f];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"e5e5e5"];
        }
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"user_name", @"");
        cell.detailTextLabel.text = [GlobalSettings defaultSettings].account;
    } else if(indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"nick_name", @"");
                cell.detailTextLabel.text = profile.nickName == nil ? [XXStringUtils emptyString] : profile.nickName;
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"mail", @"");
                cell.detailTextLabel.text = profile.mail == nil ? [XXStringUtils emptyString] : profile.mail;
                break;
            case 2:
                cell.textLabel.text = NSLocalizedString(@"modify_pwd", @"");
                cell.detailTextLabel.text = @"********";
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
//        VerificationCodeSendViewController *verificationCodeSendViewController = [[VerificationCodeSendViewController alloc] initAsModify:YES];
//        [self.navigationController pushViewController:verificationCodeSendViewController animated:YES];
    } else if(indexPath.section == 1) {
        TextViewController *textViewController = [[TextViewController alloc] init];
        if(indexPath.row == 0) {
            textViewController.delegate = self;
            textViewController.identifier = @"nickname";
            textViewController.txtDescription = NSLocalizedString(@"enter_new_nick_name", @"");
            textViewController.defaultValue = profile.nickName;
        } else if(indexPath.row == 1) {
            textViewController.delegate = self;
            textViewController.identifier = @"mail";
            textViewController.txtDescription = NSLocalizedString(@"enter_new_mail", @"");
            textViewController.defaultValue = profile.mail;
        } else {
            textViewController = [[PasswordTextViewController alloc] init];
            textViewController.delegate = self;
            textViewController.identifier = @"password";
        }
        textViewController.title = NSLocalizedString(@"profile_modify", @"");
        [self presentViewController:textViewController animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textView:(TextViewController *)textView newText:(NSString *)newText {
    if([@"mail" isEqualToString:textView.identifier]) {
        if([XXStringUtils isBlank:newText]) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"mail_not_blank", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            return;
        }
        if(![newText isEqualToString:profile.mail]) {
            profile.mail = newText;
            profileChanged = YES;
            btnSubmit.enabled = YES;
            [tblAccountSettings reloadData];
        }
    } else if([@"nickname" isEqualToString:textView.identifier]) {
        if([XXStringUtils isBlank:newText]) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"nick_name_not_blank", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            return;
        }
        if(![newText isEqualToString:profile.nickName]) {
            profile.nickName = newText;
            profileChanged = YES;
            btnSubmit.enabled = YES;
            [tblAccountSettings reloadData];
        }
    } else if([@"password" isEqualToString:textView.identifier]) {
        if([XXStringUtils isBlank:newText]) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            return;
        }
        profile.password = newText;
        profileChanged = YES;
        btnSubmit.enabled = YES;
    }
    [textView close];
}

#pragma mark -
#pragma mark Submit Changes

- (void)btnSubmitClicked:(id)sender {
    UIAlertView  *needPwdAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password_valid", @"") message:NSLocalizedString(@"enter_old_pwd", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
    [needPwdAlertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [needPwdAlertView textFieldAtIndex:0].text = [XXStringUtils emptyString];
    [needPwdAlertView show];
}

- (void)updateAccountOnComplete:(DeviceCommand *)command {
    @synchronized(self){
        if (command == nil) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
            return;
        }

        switch (command.resultID) {
            case 1:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
                profileChanged = NO;
                btnSubmit.enabled = NO;
                [self notifyMainViewScreenNameChanged];
                break;
            case -1:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"pwd_invalid", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            case -2:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"mail_name_blank", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            case -3:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"format_error", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            case -4:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_frequently", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            default:
                break;
        }
    }
}

//- (void)delayDimiss {
//    @synchronized(self){
//        if ([AlertView currentAlertView].alertViewState != AlertViewStateReady) {
//            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
//            [[AlertView currentAlertView] delayDismissAlertView];
//        }
//    }
//}



//- (BOOL)checkExternalNetwork {
//    if([[SMShared current].deliveryService.tcpService isConnectted]) {
//        return YES;
//    } else{
//        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"offline", @"") forType:AlertViewTypeFailed];
//        [[AlertView currentAlertView] delayDismissAlertView];
//        return NO;
//    }
//}

#pragma mark -
#pragma mark - UI Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1023) {
        if(buttonIndex == 1) {
            [self reallyPopupViewController];
        }
    } else {
        profile.oldPassword = [alertView textFieldAtIndex:0].text;
        [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(delaySubmit) userInfo:nil repeats:NO];
    }
}

- (void)delaySubmit {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES timeout:10.f timeoutMessage:NSLocalizedString(@"request_timeout", @"")];
    
    DeviceCommandUpdateAccount *updateAccountCommand = (DeviceCommandUpdateAccount *)[CommandFactory commandForType:CommandTypeUpdateAccount];
    updateAccountCommand.email = profile.mail;
    updateAccountCommand.screenName = profile.nickName;
    updateAccountCommand.pwdToUpdate = profile.password;
    updateAccountCommand.oldPwd = profile.oldPassword;
    [[CoreService defaultService] executeDeviceCommand:updateAccountCommand];
    profile.password = [XXStringUtils emptyString];
}

- (void)popupViewController {
    if(profileChanged) {
        UIAlertView  *promptAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"profile_changed_tips", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"discard", @""), nil];
        promptAlertView.tag = 1023;
        [promptAlertView show];
        return;
    }
    [self reallyPopupViewController];
}

- (void)reallyPopupViewController {
    [super popupViewController];
}

@end
