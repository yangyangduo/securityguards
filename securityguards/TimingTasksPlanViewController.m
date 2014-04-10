//
//  TimingTasksPlanViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTasksPlanViewController.h"
#import "TimingTaskPlanEditViewController.h"
#import "TimingTasksPlanService.h"

#define RefreshInterval 60 * 5

@interface TimingTasksPlanViewController ()

@end

@implementation TimingTasksPlanViewController {
    UITableView *tblTaskPlans;
}

@synthesize unit = _unit_;
@synthesize needRefresh;

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
        self.needRefresh = NO;
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
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(btnEditTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnEdit];
    
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

- (void)viewDidAppear:(BOOL)animated {
    if(self.needRefresh
       || self.unit.timingTasksPlan == nil
       || self.unit.timingTasksPlan.count == 0
       || self.unit.timingTasksPlanLastRefreshDate == nil) {
        [self autoTriggerRefresh];
        self.needRefresh = NO;
        return;
    }
    if(self.unit.timingTasksPlanLastRefreshDate
       .timeIntervalSinceNow >= RefreshInterval) {
        [self autoTriggerRefresh];
    }
}

- (void)autoTriggerRefresh {
    [tblTaskPlans setContentOffset:CGPointMake(0, -70) animated:YES];
    double delayInSeconds = 0.4f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshHeaderView egoRefreshScrollViewDidScroll:tblTaskPlans];
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:tblTaskPlans];
    });
}

- (void)btnEditTable:(id)sender {
    if(tblTaskPlans != nil) {
        [tblTaskPlans setEditing:!tblTaskPlans.isEditing animated:YES];
    }
}

- (void)showTimingTasksPlanEditViewController:(id)sender {
    if(self.unit == nil) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    TimingTaskPlanEditViewController *controller = [[TimingTaskPlanEditViewController alloc] initWithUnit:self.unit timingTask:nil];
    controller.preViewController = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Rest service call back

- (void)getTimingTasksPlanSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200 && resp.body != nil) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        int resultId = [json intForKey:@"i"];
        if(resultId == 1 || resultId == 2) {
            [self.unit.timingTasksPlan removeAllObjects];
            self.unit.timingTasksPlanLastRefreshDate = [NSDate date];
            NSArray *_timing_tasks_json_ = [json arrayForKey:@"m"];
            if(_timing_tasks_json_ != nil) {
                for(int i=0; i<_timing_tasks_json_.count; i++) {
                    NSDictionary *_timing_task_json_ = [_timing_tasks_json_ objectAtIndex:i];
                    TimingTask *tt = [[TimingTask alloc] initWithJson:_timing_task_json_ forUnit:self.unit];
                    tt.isOwner = (resultId == 1);
                    [self.unit.timingTasksPlan addObject:tt];
                }
                
                [self.unit.timingTasksPlan sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    TimingTask *tt1 = obj1;
                    TimingTask *tt2 = obj2;
                    
                    // if enable is yes, bring it to front on which enable is no
                    if(tt1.enable != tt2.enable) {
                        return tt1.enable ? NSOrderedAscending : NSOrderedDescending;
                    }
                    
                    // if enable is the same, compare it's date
                    else {
                        if(tt1.scheduleTimeHour > tt2.scheduleTimeHour) {
                            return NSOrderedDescending;
                        } else if(tt1.scheduleTimeHour < tt2.scheduleTimeHour) {
                            return NSOrderedAscending;
                        } else {
                            if(tt1.scheduleTimeMinute > tt2.scheduleTimeMinute) {
                                return NSOrderedDescending;
                            } else if(tt1.scheduleTimeMinute < tt2.scheduleTimeMinute) {
                                return NSOrderedAscending;
                            } else {
                                return NSOrderedSame;
                            }
                        }
                    }
                }];
            }
            [tblTaskPlans reloadData];
        }
        return;
    }
    [self getTimingTasksPlanFailed:resp];
}

- (void)getTimingTasksPlanFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 403) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
}

#pragma mark -
#pragma mark Config Task Plan Enable

- (void)timingTaskStateChanged:(TimingTasksCell *)timingTasksCell withState:(BOOL)isEnable {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    TimingTasksPlanService *service = [[TimingTasksPlanService alloc] init];
    [service updateTimingTasksPlanEnabled:timingTasksCell.timingTask enable:isEnable success:@selector(updateTimingTaskPlanStateSuccess:) failed:@selector(updateTimingTaskPlanStateFailed:) target:self callback:timingTasksCell];
}

- (void)updateTimingTaskPlanStateSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_json_ = [JsonUtils createDictionaryFromJson:resp.body];
        if(_json_ != nil) {
            TimingTasksCell *cell = resp.callbackObject;
            int result = [_json_ intForKey:@"i"];
            if(result == 1) {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
                [[XXAlertView currentAlertView] delayDismissAlertView];
                TimingTasksCell *cell = resp.callbackObject;
                cell.timingTask.enable = cell.valueForSwitchButton;
            } else {
                if(result == -2) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_bind", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                } else if(result == 0) {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_permissions", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                } else {
                    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"system_error", @"") forType:AlertViewTypeFailed];
                    [[XXAlertView currentAlertView] delayDismissAlertView];
                }
                if(cell != nil) {
                    [cell revertSwitchButton];
                }
            }
            return;
        }
    }
    [self updateTimingTaskPlanStateFailed:resp];
}

- (void)deleteTimingTask:(TimingTask *)timingTask forIndexPath:(NSIndexPath *)indexPath {
    if(timingTask == nil) return;
    if(timingTask.isSystemTask) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"can_not_delete_system_task", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"deleting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    TimingTasksPlanService *service = [[TimingTasksPlanService alloc] init];
    [service deleteTimingTask:timingTask success:@selector(deleteTimingTaskSuccess:) failed:@selector(deleteTimingTaskFailed:) target:self callback:indexPath];
}

- (void)deleteTimingTaskSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *jsonResult = [JsonUtils createDictionaryFromJson:resp.body];
        int result = [jsonResult intForKey:@"i"];
        if(result == 1) {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"delete_success", @"") forType:AlertViewTypeSuccess];
            [[XXAlertView currentAlertView] delayDismissAlertView];
            NSIndexPath *indexPath = resp.callbackObject;
            [tblTaskPlans beginUpdates];
            [self.unit.timingTasksPlan removeObjectAtIndex:indexPath.row];
            [tblTaskPlans deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tblTaskPlans endUpdates];
            if(self.unit.timingTasksPlan.count == 0) {
                tblTaskPlans.editing = NO;
            }
            return;
        } else if(result == 0) {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"has_no_permissions_del", @"") forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] delayDismissAlertView];
            return;
        }
    }
    [self deleteTimingTaskFailed:resp];
}

- (void)deleteTimingTaskFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 403) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[XXAlertView currentAlertView] delayDismissAlertView];
#ifdef DEBUG
    NSLog(@"[TIMING TASK VC] Delete timing task failed, status code is %d", resp.statusCode);
#endif
}

- (void)updateTimingTaskPlanStateFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 403) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[XXAlertView currentAlertView] delayDismissAlertView];
    TimingTasksCell *cell = resp.callbackObject;
    if(cell != nil) {
        [cell revertSwitchButton];
    }
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
    TimingTask *timingTask = [self.unit.timingTasksPlan objectAtIndex:indexPath.row];
    if(cell == nil) {
        cell = [[TimingTasksCell alloc] initWithTimerTaskPlan:timingTask reuseIdentifier:cellIdentifier];
        cell.delegte = self;
    }
    cell.timingTask = timingTask;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimingTask *timingTask = [self.unit.timingTasksPlan objectAtIndex:indexPath.row];
    TimingTaskPlanEditViewController *controller = [[TimingTaskPlanEditViewController alloc] initWithUnit:self.unit timingTask:[timingTask copy]];
    controller.preViewController = self;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"delete", @"");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    TimingTask *timingTask = [self.unit.timingTasksPlan objectAtIndex:indexPath.row];
    [self deleteTimingTask:timingTask forIndexPath:indexPath];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
    if(tblTaskPlans.isEditing) {
        [tblTaskPlans setEditing:NO animated:NO];
    }
    TimingTasksPlanService *service = [[TimingTasksPlanService alloc] init];
    [service timingTasksPlanForUnitIdentifier:self.unit.identifier success:@selector(getTimingTasksPlanSuccess:) failed:@selector(getTimingTasksPlanFailed:) target:self callback:nil];
	_reloading = YES;
}

- (void)doneLoadingTableViewData {
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tblTaskPlans];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
