//
//  UnitDetailsViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitDetailsViewController.h"

@interface UnitDetailsViewController ()

@end

@implementation UnitDetailsViewController {
    UITableView *tblDevices;
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
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"device_management", @"");
    
    tblDevices = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    tblDevices.delegate = self;
    tblDevices.dataSource = self;
    
    [self.view addSubview:tblDevices];
}

- (void)popupViewController {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark -
#pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
