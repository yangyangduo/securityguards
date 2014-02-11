//
//  ShoppingViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingStateView.h"

@interface ShoppingViewController ()

@end

@implementation ShoppingViewController {
    UITableView *tblMerchandises;
    
    UIView *bottomBar;
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

- (void)initUI {
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"shopping_online", @"");
    ShoppingStateView *shoppingStateView = [[ShoppingStateView alloc] initWithPoint:CGPointMake(0, self.topbarView.bounds.size.height) shoppingState:ShoppingStateSelecting];
    [self.view addSubview:shoppingStateView];
    
    tblMerchandises = [[UITableView alloc] initWithFrame:CGRectMake(0, shoppingStateView.frame.origin.y + shoppingStateView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - shoppingStateView.bounds.size.height) style:UITableViewStylePlain];
    tblMerchandises.delegate = self;
    tblMerchandises.dataSource = self;
    [self.view addSubview:tblMerchandises];
}

#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
