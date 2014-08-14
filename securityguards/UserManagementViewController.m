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
#import "AccountManageCell.h"

#define BTN_WIDTH                   100
#define BTN_HEIGHT                  CELL_HEIGHT - 5
#define REFRESH_AGAIN_DURATION      2
#define ACCESSORY_TAG               1998

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
    UISegmentedControl *scPanel;
    UILabel *lblUserBindingCount;
    
    BOOL buttonPanelViewIsVisable;
    BOOL currentIsOwner;
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
    buttonPanelViewIsVisable = NO;
    
    if (unitBindingAccounts == nil) {
        unitBindingAccounts = [NSMutableArray array];
    }
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"user_mgr_drawer_title", @"");
    self.view.backgroundColor = [UIColor appGray];

    UIView *bindingDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, 81)];
    bindingDetailView.backgroundColor = [UIColor whiteColor];

    UIImageView *imgUserBinding = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 150 / 2, 122 / 2)];
    imgUserBinding.image = [UIImage imageNamed:@"icon_binding_account"];
    [bindingDetailView addSubview:imgUserBinding];

    UILabel *lblUserBindingTitle = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, 80, 21)];
    lblUserBindingTitle.text = @"账户绑定数:";
    lblUserBindingTitle.font = [UIFont systemFontOfSize:14.f];
    lblUserBindingTitle.backgroundColor = [UIColor clearColor];
    [bindingDetailView addSubview:lblUserBindingTitle];

    lblUserBindingCount = [[UILabel alloc] initWithFrame:CGRectMake(166, 2, 70, 30)];
    lblUserBindingCount.text = @"0 / 0";
    lblUserBindingCount.textAlignment = NSTextAlignmentCenter;
    lblUserBindingCount.textColor = [UIColor orangeColor];
    lblUserBindingCount.backgroundColor = [UIColor clearColor];
    lblUserBindingCount.font = [UIFont boldSystemFontOfSize:24.f];
    [bindingDetailView addSubview:lblUserBindingCount];

    UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(239, 10, 20, 21)];
    lblUnit.text = @"个";
    lblUnit.font = [UIFont systemFontOfSize:14.f];
    lblUnit.backgroundColor = [UIColor clearColor];
    [bindingDetailView addSubview:lblUnit];

    UILabel *lblSmsTips = [[UILabel alloc] initWithFrame:CGRectMake(85, 35, 225, 40)];
    lblSmsTips.numberOfLines = 2;
    lblSmsTips.font = [UIFont systemFontOfSize:11.f];
    lblSmsTips.backgroundColor = [UIColor clearColor];
    lblSmsTips.textColor = [UIColor lightGrayColor];
    lblSmsTips.text = @"只有绑定用户才允许在3G/4G网络中控制,其他用户仅允许需在内网WIFI下临时使用设备。";
    [bindingDetailView addSubview:lblSmsTips];

    [self.view addSubview:bindingDetailView];

    if(tblUnits == nil) {
        tblUnits = [[PullTableView alloc] initWithFrame:CGRectMake(0, bindingDetailView.frame.origin.y + bindingDetailView.bounds.size.height, self.view.bounds.size.width, self.view.frame.size.height - self.topbarView.bounds.size.height - bindingDetailView.bounds.size.height) style:UITableViewStylePlain];
        tblUnits.pullDelegate = self;
        tblUnits.center = CGPointMake(self.view.center.x, tblUnits.center.y);
        tblUnits.delegate = self;
        tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tblUnits];
    }
    
    if (buttonPanelView == nil) {
        buttonPanelView = [[UIView alloc] initWithFrame:CGRectMake(10, 5,CELL_WIDTH, BTN_HEIGHT)];
        buttonPanelView.backgroundColor = [UIColor appWhite];
        if (btnMsg == nil) {
            btnMsg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,BTN_WIDTH , BTN_HEIGHT)];
            [btnMsg setBackgroundImage:[UIImage imageNamed:@"icon_white_msg.png"] forState:UIControlStateNormal];
            [btnMsg setBackgroundImage:[UIImage imageNamed:@"icon_gray_msg.png"] forState:UIControlStateHighlighted];
            [btnMsg addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnMsg];
        }
        
        if (btnPhone == nil) {
            btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(btnMsg.frame.origin.x+BTN_WIDTH, 0,BTN_WIDTH , BTN_HEIGHT)];
            [btnPhone setBackgroundImage:[UIImage imageNamed:@"icon_white_dial_phone.png"] forState:UIControlStateNormal];
            [btnPhone setBackgroundImage:[UIImage imageNamed:@"icon_gray_dial_phone.png"] forState:UIControlStateHighlighted];
            [btnPhone addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnPhone];
        }
        
        if (btnUnbinding == nil) {
            btnUnbinding = [[UIButton alloc] initWithFrame:CGRectMake(btnPhone.frame.origin.x+BTN_WIDTH,0,BTN_WIDTH , BTN_HEIGHT)];
            [btnUnbinding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnUnbinding.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnUnbinding setBackgroundImage:[UIImage imageNamed:@"icon_white_unbind.png"] forState:UIControlStateNormal];
            [btnUnbinding setBackgroundImage:[UIImage imageNamed:@"icon_gray_unbind.png"] forState:UIControlStateHighlighted];
            [btnUnbinding addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnUnbinding];
        }
    }
}

- (void)setUp {
    [super setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    // current unit is empty
    if([UnitManager defaultManager].currentUnit == nil) {
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

- (void)addPanelData:(AccountManageCellData *)data {
    if (!unitBindingAccounts) return;
    [unitBindingAccounts insertObject:data atIndex:curIndexPath.row+1];
}

- (void)removePanelData {
    if (!unitBindingAccounts || unitBindingAccounts.count <= curIndexPath.row+1) {
        return;
    }
    [unitBindingAccounts removeObjectAtIndex:curIndexPath.row+1];
}

- (void)showButtons {
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
    } else {
        if (!currentIsOwner) {
            btnUnbinding.hidden = YES;
        }
    }
    if (buttonPanelView.superview != nil) {
        [scPanel removeFromSuperview];
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
        UIAlertView  *confirmAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tips", @"") message:[NSString stringWithFormat:@"是否确定解除用户[%@]与主控[%@]的绑定关系?", selectedUser.name,[UnitManager defaultManager].currentUnit.name] delegate:self cancelButtonTitle:NSLocalizedString(@"determine", @"") otherButtonTitles:NSLocalizedString(@"cancel", @""), nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userCellIdentifier = @"userCellIdentifier";
    static NSString *panelCellIdentifier = @"panelIdentifier";
    
    AccountManageCellData *data = [unitBindingAccounts objectAtIndex:indexPath.row];
    AccountManageCell *cell = [tableView dequeueReusableCellWithIdentifier:data.isPanel ? panelCellIdentifier : userCellIdentifier];
    
    if(data != nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:data.isPanel ? panelCellIdentifier : userCellIdentifier];
    }
    if (cell == nil) {
        cell = [[AccountManageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:data.isPanel ? panelCellIdentifier : userCellIdentifier];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    }
    if(data.isPanel) {
        UIView *customView = (UIView *)[cell viewWithTag:CUSTOM_VIEW_TAG];
        if (customView != nil) {
            [customView removeFromSuperview];
        }
        [self showButtons];
        [cell addSubview:buttonPanelView];
    } else {
        [cell loadData:data];
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
    UITableViewCell *curCell = [tblUnits cellForRowAtIndexPath:curIndexPath];
    CGAffineTransform transformOpen = CGAffineTransformMakeRotation(-M_PI/2);
    CGAffineTransform transformClose = CGAffineTransformMakeRotation(0);
    UITableViewCell *selectedCell = [tblUnits cellForRowAtIndexPath:indexPath];
    if (curCell != nil) {
        UIImageView *curAccessoryView = (UIImageView *)[curCell viewWithTag:ACCESSORY_TAG];
        curAccessoryView.transform = transformClose;
    }
    UIImageView *selectedAccessoryView = (UIImageView *)[selectedCell viewWithTag:ACCESSORY_TAG];
    selectedAccessoryView.transform = transformOpen;

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
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    UserManagementService *userManagementService = [[UserManagementService alloc] init];
    [userManagementService unBindUnit:curUnitIdentifier forUser:selectedUser.identifier success:@selector(unbindingSuccess:) failed:@selector(unbindingFailed:) target:self callback:nil];
}


- (void)refreshDataIsOk {
    if(tblUnits != nil && tblUnits.pullTableIsRefreshing) {
        tblUnits.pullTableIsRefreshing = NO;
    }
}

- (void)refresh {
    UserManagementService *userManagementService = [[UserManagementService alloc] init];
    [userManagementService usersForUnit:curUnitIdentifier success:@selector(getUsersForUnitSuccess:) failed:@selector(getUsersForUnitFailed:) target:self callback:nil];
}

#pragma mark -
#pragma mark Handle success and failed

- (void)getUsersForUnitSuccess:(RestResponse *)resp {
    if (resp && resp.statusCode == 200) {
        [unitBindingAccounts removeAllObjects];
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            int result = [json intForKey:@"i"];
            if(result == 1) {
                NSString *maxUsers = [json stringForKey:@"d"];
                NSArray *usersJson = [json arrayForKey:@"m"];
                if(usersJson != nil) {
                    [unitBindingAccounts removeAllObjects];
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
                    lblUserBindingCount.text = [NSString stringWithFormat:@"%d / %@", usersJson.count, maxUsers == nil ? @"0" : maxUsers];
                    [self performSelector:@selector(refreshDataIsOk) withObject:nil afterDelay:0.5f];
                    return;
                } else {
                    lblUserBindingCount.text = [NSString stringWithFormat:@"0 / 0"];
                }
            }
        }
    }
    [self getUsersForUnitFailed:resp];
}

- (void)getUsersForUnitFailed:(RestResponse *) resp{
    tblUnits.pullTableIsRefreshing = NO;
    if(resp != nil && abs(resp.statusCode) == 1001) {
        // 超时处理
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    }  else {
        // Error
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    }
}

- (void)unbindingSuccess:(RestResponse *)resp {
    if (resp && resp.statusCode == 200) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"execution_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
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
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        return;
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    }  else {
        // Error
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] delayDismissAlertView];
    }
}

@end
