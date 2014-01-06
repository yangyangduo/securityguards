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
#import "PullTableView.h"
#import "UserManagementService.h"

#define BTN_MARGIN                  35
#define BTN_WIDTH                   41 / 2
#define BTN_HEIGHT                  41 / 2
#define REFRESH_AGAIN_DURATION      2


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
    

    
    
    
    
    
}

- (void)setUp {
    [super setUp];
}

@end
