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

@interface UserManagementViewController ()

@end

@implementation UserManagementViewController{
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
    
}

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"user_mgr_drawer_title", @"");
    

    
    
    
    
    
}

- (void)setUp {
    [super setUp];
}

@end
