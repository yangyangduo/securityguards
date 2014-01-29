//
//  TimingTasksPlanViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTasksPlanViewController.h"
#import "TimingTaskPlanEditViewController.h"
#import "TimingTasksCell.h"
#import "TimingTasksPlanService.h"

@interface TimingTasksPlanViewController ()

@end

@implementation TimingTasksPlanViewController {
    UITableView *tblTaskPlans;
}

@synthesize unit = _unit_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithUnit:(Unit *)unit {
    self = [super init];
    if(self) {
        _unit_ = unit;
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
    
    self.topbarView.title =
        self.unit == nil ? NSLocalizedString(@"task_timer_title", @"") : self.unit.name;
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(showTimingTasksPlanEditViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRight];
    
    tblTaskPlans = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStylePlain];
    tblTaskPlans.delegate = self;
    tblTaskPlans.dataSource = self;
    
    [self.view addSubview:tblTaskPlans];

    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tblTaskPlans.bounds.size.height, tblTaskPlans.frame.size.width, tblTaskPlans.bounds.size.height) arrowImageName:@"grayArrow" textColor:[UIColor lightGrayColor]];
    _refreshHeaderView.backgroundColor = [UIColor whiteColor];
    _refreshHeaderView.delegate = self;
    [tblTaskPlans addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)showTimingTasksPlanEditViewController:(id)sender {
    if(self.unit == nil) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [self.navigationController pushViewController:[[TimingTaskPlanEditViewController alloc] initWithUnit:self.unit timingTask:nil] animated:YES];
}

#pragma mark -
#pragma mark Rest service call back

- (void)getTimingTasksPlanSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200 && resp.body != nil) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        int resultId = [json intForKey:@"i"];
        if(resultId == 1 || resultId == 2) {
            NSArray *_timing_tasks_json_ = [json arrayForKey:@"m"];
            if(_timing_tasks_json_ == nil || _timing_tasks_json_.count == 0) {
                [self.unit.timingTasksPlan removeAllObjects];
            } else {
                for(int i=0; i<_timing_tasks_json_.count; i++) {
                    NSDictionary *_timing_task_json_ = [_timing_tasks_json_ objectAtIndex:i];
                    TimingTask *tt = [[TimingTask alloc] initWithJson:_timing_task_json_ forUnit:self.unit];
                    tt.isOwner = resultId == 1;
                    [self.unit.timingTasksPlan addObject:tt];
                }
            }
            [tblTaskPlans reloadData];
        }
        return;
    }
    
    [self getTimingTasksPlanFailed:resp];
}

- (void)getTimingTasksPlanFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 403) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
}

#pragma mark -
#pragma mark Table view deleagte

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.unit == nil || self.unit.timingTasksPlan == nil) return 0;
    return self.unit.timingTasksPlan.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

// to add a foot view for table is order to delete unnecessary seperator lines
// for table view default implementations
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    TimingTasksCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[TimingTasksCell alloc] initWithTimerTaskPlan:nil reuseIdentifier:cellIdentifier];
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[TimingTaskPlanEditViewController alloc] initWithUnit:self.unit timingTask:nil] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    TimingTasksPlanService *service = [[TimingTasksPlanService alloc] init];
    [service timingTasksPlanForUnitIdentifier:self.unit.identifier success:@selector(getTimingTasksPlanSuccess:) failed:@selector(getTimingTasksPlanFailed:) target:self callback:nil];
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tblTaskPlans];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
