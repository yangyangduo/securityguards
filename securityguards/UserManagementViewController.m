//
//  UserManagementViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserManagementViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+MoreColor.h"
#import "XXButton.h"
#import "Users.h"
#import "UserManagementService.h"
#import "AccountManageCellData.h"
#import "SystemService.h"
#import "UnitManager.h"

#define BTN_MARGIN                  35
#define BTN_WIDTH                   41 / 2
#define BTN_HEIGHT                  41 / 2
#define REFRESH_AGAIN_DURATION      2
#define CELL_HEIGHT                 93/2
#define CELL_WIDTH                  624/2


@interface UserManagementViewController ()

@end

@implementation UserManagementViewController{
    PullTableView *tblUnits;
    NSString *curUnitIdentifier;
    NSMutableArray *unitBindingAccounts;
    
    User *selectedUser;
    NSIndexPath *curIndexPath;
    
    UIView *buttonPanelView;
    UIButton *btnMsg;
    UIButton *btnPhone;
    UIButton *btnUnbinding;
    
    UserManagementService *userManagementService;
    
    BOOL buttonPanelViewIsVisable;
    BOOL currentIsOwner;
    
    //    NSDate *lastRereshDate;
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

- (void)viewWillAppear:(BOOL)animated {
    // current unit is empty
    if([XXStringUtils isBlank:[UnitManager defaultManager].currentUnit.identifier]) {
        buttonPanelViewIsVisable = NO;
        if(unitBindingAccounts != nil) {
            [unitBindingAccounts removeAllObjects];
            [tblUnits reloadData];
        }
        return;
    } else {
        // current unit not changed
        if([[UnitManager defaultManager].currentUnit.identifier isEqualToString:curUnitIdentifier]) {
            // check refresh is too often ?
            if(tblUnits.pullLastRefreshDate != nil) {
                NSTimeInterval timerInterval = [[NSDate date] timeIntervalSinceDate:tblUnits.pullLastRefreshDate];
                double minutes = timerInterval / 60;
                if(minutes < REFRESH_AGAIN_DURATION) return;
            }
        } else {
            curUnitIdentifier = [UnitManager defaultManager].currentUnit.identifier;
            buttonPanelViewIsVisable = NO;
        }
    }
    
    tblUnits.pullTableIsRefreshing = YES;
    [self pullTableViewDidTriggerRefresh:tblUnits];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)initDefaults {
    [super initDefaults];
    buttonPanelViewIsVisable = NO;
    if (userManagementService == nil) {
        userManagementService = [[UserManagementService alloc] init];
    }
    
    if (unitBindingAccounts == nil) {
        unitBindingAccounts = [NSMutableArray array];
    }
}

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"user_mgr_drawer_title", @"");
    if(tblUnits == nil) {
        tblUnits = [[PullTableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height+5, self.view.bounds.size.width, self.view.frame.size.height - self.topbarView.bounds.size.height-5) style:UITableViewStylePlain];
        tblUnits.pullDelegate = self;
        tblUnits.pullTextColor = [UIColor lightTextColor];
        tblUnits.pullArrowImage = [UIImage imageNamed:@"whiteArrow"];
        tblUnits.center = CGPointMake(self.view.center.x, tblUnits.center.y);
        tblUnits.delegate = self;
        tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tblUnits];
    }
    
    if (buttonPanelView == nil) {
        buttonPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CELL_WIDTH/2, CELL_HEIGHT/2)];
        buttonPanelView.backgroundColor = [UIColor clearColor];
        if (btnMsg == nil) {
            btnMsg = [[UIButton alloc] initWithFrame:CGRectMake(46, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnMsg setBackgroundImage:[UIImage imageNamed:@"icon_send_message.png"] forState:UIControlStateNormal];
            btnMsg.center = CGPointMake(btnMsg.center.x, buttonPanelView.center.y);
            [btnMsg addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnMsg];
        }
        
        if (btnPhone == nil) {
            btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(btnMsg.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnPhone setBackgroundImage:[UIImage imageNamed:@"icon_dial_phone.png"] forState:UIControlStateNormal];
            btnPhone.center = CGPointMake(btnPhone.center.x,buttonPanelView.center.y);
            [btnPhone addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnPhone];
        }
        
        if (btnUnbinding == nil) {
            btnUnbinding = [[UIButton alloc] initWithFrame:CGRectMake(btnPhone.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnUnbinding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnUnbinding.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnUnbinding setBackgroundImage:[UIImage imageNamed:@"icon_unbind.png"] forState:UIControlStateNormal];
            btnUnbinding.center = CGPointMake(btnUnbinding.center.x, buttonPanelView.center.y);
            [btnUnbinding addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnUnbinding];
        }
    }
}

- (void) addPanelData:(AccountManageCellData *) data{
    if (!unitBindingAccounts) {
        return;
    }
    [unitBindingAccounts insertObject:data atIndex:curIndexPath.row+1];
}

- (void)removePanelData {
    if (!unitBindingAccounts||unitBindingAccounts.count<=curIndexPath.row+1) {
        return;
    }
    [unitBindingAccounts removeObjectAtIndex:curIndexPath.row+1];
}

- (void)showButton {
    AccountManageCellData *data = (AccountManageCellData *)[unitBindingAccounts objectAtIndex:curIndexPath.row];
    User *user = data.user;
    if (user == nil) {
        return;
    }
    btnMsg.hidden = NO;
    btnPhone.hidden = NO;
    btnUnbinding.hidden = NO;
    if (user.isCurrentUser) {
        if (user.isOwner) {
            btnUnbinding.hidden = YES;
        }
    }else{
        if (!currentIsOwner) {
            btnUnbinding.hidden = YES;
        }
    }
    if (buttonPanelView.superview) {
        [buttonPanelView removeFromSuperview];
    }
}


#pragma mark -
#pragma mark Events

- (void)btnPressed:(UIButton *)sender {
    if([sender isEqual:btnMsg]) {
        [SystemService messageToMobile:selectedUser.mobile withMessage:nil];
    } else if ([sender isEqual:btnPhone]){
        [SystemService dialToMobile:selectedUser.mobile];
    } else if ([sender isEqual:btnUnbinding]){
        UIAlertView  *confirmAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tips", @"") message:[NSString stringWithFormat: NSLocalizedString(@"confirm.unbinding", @""),selectedUser.name,[UnitManager defaultManager].currentUnit.name] delegate:self cancelButtonTitle:NSLocalizedString(@"determine", @"") otherButtonTitles:NSLocalizedString(@"cancel", @""), nil];
        confirmAlertView.tag = 1023;
        [confirmAlertView dismissWithClickedButtonIndex:1 animated:YES];
        [confirmAlertView show];
    }
}

#pragma mark
#pragma mark- Table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return unitBindingAccounts == nil ? 0 : unitBindingAccounts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userCellIdentifier = @"userCellIdentifier";
    static NSString *panelCellIdentifier = @"panelIdentifier";
    
    AccountManageCellData *data = [unitBindingAccounts objectAtIndex:indexPath.row];
    if(data == nil) return nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:data.isPanel ? panelCellIdentifier : userCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:data.isPanel ? panelCellIdentifier : userCellIdentifier];
        
        // cell style
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        // cell font style
        cell.textLabel.font = [UIFont systemFontOfSize:13.f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.f];
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        
        // cell separator line
        UIView *separatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(46, cell.bounds.size.height - 0.7, cell.bounds.size.width, 0.7)];
        separatorLineView.backgroundColor = [UIColor lightGrayColor];
        separatorLineView.alpha = 0.7;
        [cell addSubview:separatorLineView];
        
        // cell accessory
        if(data.isPanel) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundView.backgroundColor = [UIColor lightTextColor];
            cell.backgroundColor = [UIColor lightTextColor];
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if(data.isPanel) {
        [self showButton];
        [cell addSubview:buttonPanelView];
    } else {
        User *user = data.user;
        if(user != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)" ,user.name,user.mobile];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   ", [user stringForUserState]];
            if(user.isCurrentUser) {
                if (user.userState == UserStateOnline) {
                    cell.imageView.image = [UIImage imageNamed:user.isOwner ? @"icon_me_owner.png" : @"icon_me.png"];
                }else{
                    cell.imageView.image = [UIImage imageNamed:user.isOwner ? @"icon_me_owner.png" : @"icon_me_offline.png"];
                }
            } else {
                if (user.userState == UserStateOnline) {
                    cell.imageView.image = [UIImage imageNamed:user.isOwner ? @"icon_owner.png" : @"transparent.png"];
                }else{
                    cell.imageView.image = [UIImage imageNamed:user.isOwner ? @"icon_owner_offline.png" : @"transparent.png"];
                }
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < unitBindingAccounts.count) {
        AccountManageCellData *selectData = (AccountManageCellData *)[unitBindingAccounts objectAtIndex:indexPath.row];
        if (selectData.isPanel) return;
        selectedUser = selectData.user;
    } else {
        return;
    }
    
    if(!buttonPanelViewIsVisable) {
        [self showButtonPanelViewAtIndexPath:indexPath];
    } else {
        if (![curIndexPath isEqual:indexPath] && curIndexPath.row!=indexPath.row-1) {
            [self hideButtonPanelView];
            if(curIndexPath.row+1<indexPath.row) {
                [self showButtonPanelViewAtIndexPath:[NSIndexPath indexPathForRow:unitBindingAccounts.count-1>=indexPath.row?indexPath.row-1:unitBindingAccounts.count-1 inSection:0]];
            } else{
                [self showButtonPanelViewAtIndexPath:[NSIndexPath indexPathForRow:unitBindingAccounts.count-1>=indexPath.row+1?indexPath.row:unitBindingAccounts.count-1 inSection:0]];
            }
        }
    }
}

- (void)showButtonPanelViewAtIndexPath:(NSIndexPath *) indexPath {
    buttonPanelViewIsVisable = YES;
    curIndexPath = indexPath;
    AccountManageCellData *data = [[AccountManageCellData alloc] init];
    data.isPanel = YES;
    [self addPanelData:data];
    [tblUnits beginUpdates];
    [tblUnits insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tblUnits endUpdates];
}

- (void)hideButtonPanelView {
    buttonPanelViewIsVisable = NO;
    [self removePanelData];
    [tblUnits beginUpdates];
    [tblUnits deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:curIndexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tblUnits endUpdates];
}

#pragma mark -
#pragma mark Pull table view delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [self refresh];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    // no implementations
}

#pragma mark -
#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1023&& buttonIndex == 0) {
        [self hideButtonPanelView];
        [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(delayProcess) userInfo:nil repeats:NO];
    }
}

- (void)delayProcess {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [userManagementService unBindUnit:curUnitIdentifier forUser:selectedUser.identifier success:@selector(unbindingSuccess:) failed:@selector(unbindingFailed:) target:self callback:nil];
}


- (void)refreshDataIsOk {
    if(tblUnits != nil && tblUnits.pullTableIsRefreshing) {
        tblUnits.pullTableIsRefreshing = NO;
    }
}

- (void)refresh {
    [userManagementService usersForUnit:curUnitIdentifier success:@selector(getUsersForUnitSuccess:) failed:@selector(getUsersForUnitFailed:) target:self callback:nil];
}

#pragma mark -
#pragma mark Handle success and failed

- (void)getUsersForUnitSuccess:(RestResponse *)resp {
    if (resp && resp.statusCode == 200) {
        [unitBindingAccounts removeAllObjects];
        NSArray *usersJson = [JsonUtils createDictionaryFromJson:resp.body];
        if(usersJson != nil) {
            Users *users = [[Users alloc] initWithJson:[NSDictionary dictionaryWithObject:usersJson forKey:@"users"]];
            for (User *user in users.users) {
                AccountManageCellData *cellData = [[AccountManageCellData alloc] init];
                cellData.user = user;
                cellData.isPanel = NO;
                [unitBindingAccounts addObject:cellData];
            }
            currentIsOwner = NO;
            for (AccountManageCellData *data in unitBindingAccounts) {
                if (data.user.isOwner&&data.user.isCurrentUser) {
                    currentIsOwner = YES;
                    break;
                }
            }
            buttonPanelViewIsVisable = NO;
            [tblUnits reloadData];
            tblUnits.pullLastRefreshDate = [NSDate date];
            
            [self performSelector:@selector(refreshDataIsOk) withObject:nil afterDelay:0.5f];
            return;
        }
    }
    [self getUsersForUnitFailed:resp];
}

- (void)getUsersForUnitFailed:(RestResponse *) resp{
    tblUnits.pullTableIsRefreshing = NO;
    if(resp != nil && abs(resp.statusCode) == 1001) {
        // 超时处理
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    } else {
        // Error
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    }
}

- (void)unbindingSuccess:(RestResponse *) resp{
    if (resp && resp.statusCode == 200) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"execution_success", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] delayDismissAlertView];
        if (selectedUser.isCurrentUser) {
            [[CoreService defaultService] executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
        }
        return;
    }
    [self unbindingFailed:resp];
}

- (void)unbindingFailed:(RestResponse *) resp{
    if(resp != nil && abs(resp.statusCode) == 1001) {
        // 超时处理
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
        return;
    } else {
        // Error
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
    }
}

- (void)destory {
#ifdef DEBUG
    NSLog(@"AccountManagement View] Destoryed.");
#endif
}







- (void)setUp {
    [super setUp];
}

@end
