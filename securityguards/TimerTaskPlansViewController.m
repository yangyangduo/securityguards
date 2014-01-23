//
//  TimerTaskPlansViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimerTaskPlansViewController.h"

@interface TimerTaskPlansViewController ()

@end

@implementation TimerTaskPlansViewController {
    UITableView *tblTaskPlans;
    NSArray *taskPlans;
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
    
    self.topbarView.title = NSLocalizedString(@"task_timer_title", @"");
    
    tblTaskPlans = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStylePlain];
    tblTaskPlans.delegate = self;
    tblTaskPlans.dataSource = self;
    
    [self.view addSubview:tblTaskPlans];
}

#pragma mark -
#pragma mark Table view deleagte

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskPlans == nil ? 0 : taskPlans.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    return cell;
}

@end
