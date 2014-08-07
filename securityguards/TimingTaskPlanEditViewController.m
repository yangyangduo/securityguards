//
//  TimingTaskPlanEditViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTaskPlanEditViewController.h"
#import "TimingTaskScheduleDateEditViewController.h"
#import "TimingTasksPlanService.h"
#import "TimingTasksPlanViewController.h"
#import "DeviceUtils.h"
#import "XXActionSheet.h"

typedef enum {
    ControllerModeCreate,
    ControllerModeEdit,
} ControllerMode;

typedef enum {
    UserPermisionReadOnly,
    UserPermisionReadWrite,
} UserPermision;

@interface TimingTaskPlanEditViewController ()

@end

@implementation TimingTaskPlanEditViewController {
    UITableView *tblTimerTaskPlans;
    UIDatePicker *datePicker;
    
    ControllerMode _mode_;
    UserPermision _user_permision_;
}

@synthesize unit = _unit_;
@synthesize timingTask = _timingTask_;
@synthesize preViewController;

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

- (instancetype)initWithUnit:(Unit *)unit timingTask:(TimingTask *)timingTask {
    self = [super init];
    if(self) {
        _unit_ = unit;
        _timingTask_ = timingTask;
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
    
    if(self.timingTask == nil) {
        _mode_ = ControllerModeCreate;
        self.timingTask = [[TimingTask alloc] initWithUnit:self.unit];
    } else {
        _mode_ = ControllerModeEdit;
    }
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = self.unit == nil ? NSLocalizedString(@"task_timer_title", @"") : self.unit.name;
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"icon_save"] forState:UIControlStateNormal];
    [btnRight setTitle:[NSString stringWithFormat:@"  %@", NSLocalizedString(@"determine", @"")] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(saveTimingTasksPlan:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRight];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, 120)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.minuteInterval = 5;
    [self.view addSubview:datePicker];
    
    tblTimerTaskPlans = [[UITableView alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y + datePicker.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - datePicker.bounds.size.height) style:UITableViewStyleGrouped];
    tblTimerTaskPlans.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblTimerTaskPlans.backgroundView = nil;
    tblTimerTaskPlans.delegate = self;
    tblTimerTaskPlans.dataSource = self;
    
    [self.view addSubview:tblTimerTaskPlans];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (void)refresh {
    if(self.timingTask != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        datePicker.date = [formatter dateFromString:[NSString stringWithFormat:@"%d:%d", self.timingTask.scheduleTimeHour, self.timingTask.scheduleTimeMinute]];
    }
    
    if(tblTimerTaskPlans != nil) {
        [tblTimerTaskPlans reloadData];
    }
}

#pragma mark -
#pragma mark Timing task plan save service

- (void)saveTimingTasksPlan:(id)sender {
    if(self.timingTask != nil) {
        // set hour && minute
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:datePicker.date];
        self.timingTask.scheduleTimeHour = components.hour;
        self.timingTask.scheduleTimeMinute = components.minute;
        
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        
        TimingTasksPlanService *service = [[TimingTasksPlanService alloc] init];
        [service saveTimingTasksPlan:self.timingTask success:@selector(saveTimingTasksSuccess:) failed:@selector(saveTimingTasksFailed:) target:self callback:nil];
    }
}

- (void)saveTimingTasksSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_json_ = [JsonUtils createDictionaryFromJson:resp.body];
        if(_json_ != nil) {
            int result = [_json_ intForKey:@"i"];
            if(result == 1) {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
                [[XXAlertView currentAlertView] delayDismissAlertView];
                if(self.preViewController != nil) {
                    TimingTasksPlanViewController *controller = (TimingTasksPlanViewController *)self.preViewController;
                    controller.needRefresh = YES;
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else if(result == 0) {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_permissions", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] delayDismissAlertView];
            } else if(result == -2) {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_bind", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] delayDismissAlertView];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"system_error", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] delayDismissAlertView];
            }
            return;
        }
    }
    [self saveTimingTasksFailed:resp];
}

- (void)saveTimingTasksFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[Timing Task Plan Edit VC] Save timing task failed, status code is %d.", resp.statusCode);
#endif
    
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
}

#pragma mark -
#pragma mark Text view controller

- (void)textView:(TextViewController *)textView newText:(NSString *)newText {
    if([XXStringUtils isBlank:newText]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"timing_tasks_plan_name_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    self.timingTask.name = newText;
    [textView popupViewController];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 2;
    return (self.timingTask == nil || self.timingTask.timingTaskExecutionItems == nil)
        ? 0 : self.timingTask.timingTaskExecutionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifierForFirstSection = @"cellIdentifier_f";
    static NSString *cellIdentifierForSecondSection = @"cellIdentifier_s";
    UITableViewCell *cell = nil;
    if(indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstSection];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierForFirstSection];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            cell.selectedBackgroundView.backgroundColor = [UIColor appYellow];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1)];
            viewLine.backgroundColor = [UIColor appGray];
            [cell addSubview:viewLine];
        }
        if(indexPath.row == 0) {
            cell.detailTextLabel.text = NSLocalizedString(@"change_plan_name", @"");
            cell.textLabel.text = self.timingTask.name;
        } else if(indexPath.row == 1) {
            cell.detailTextLabel.text = NSLocalizedString(@"change_schedule_date", @"");
            cell.textLabel.text = [self.timingTask stringForScheduleDate];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSecondSection];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSecondSection];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            cell.selectedBackgroundView.backgroundColor = [UIColor appYellow];
            if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
                cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            }
            
            UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 150, 7, 120, 29)];
            detailTextLabel.tag = 888;
            detailTextLabel.backgroundColor = [UIColor clearColor];
            detailTextLabel.textAlignment = NSTextAlignmentRight;
            detailTextLabel.font = [UIFont systemFontOfSize:16.f];
            [cell addSubview:detailTextLabel];
            
            UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 2, cell.bounds.size.width, 2)];
            imgLine.image = [UIImage imageNamed:@"line_dashed_h"];
            [cell addSubview:imgLine];
            
            UIImageView *imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 20, 7.3f, 3.5f, 27.5f)];
            imgLine2.image = [UIImage imageNamed:@"line_dashed_v"];
            [cell addSubview:imgLine2];
        }
        
        UILabel *detailTextLabel = (UILabel *)[cell viewWithTag:888];
        detailTextLabel.textColor = [UIColor colorWithHexString:@"666666"];
        
        if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor appDarkGray];
        } else {
            cell.backgroundView.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor appDarkGray];
        }
        
        TimingTaskExecutionItem *eachItem = [self.timingTask.timingTaskExecutionItems objectAtIndex:indexPath.row];
        
        if(eachItem != nil) {
            // set icon
            if(eachItem.device.isAirPurifierPower) {
                cell.imageView.image = [UIImage imageNamed:@"icon_power"];
            } else if(eachItem.device.isAirPurifierLevel) {
                cell.imageView.image = [UIImage imageNamed:@"icon_level"];
            } else if(eachItem.device.isAirPurifierModeControl) {
                cell.imageView.image = [UIImage imageNamed:@"icon_control_mode"];
            } else if(eachItem.device.isAirPurifierSecurity) {
                cell.imageView.image = [UIImage imageNamed:@"icon_security"];
            } else if(eachItem.device.isSocket) {
                cell.imageView.image = [UIImage imageNamed:@"icon_socket"];
            }
            
            // set text && detail text label
            cell.textLabel.text = eachItem.device.name;
            if(eachItem.isAvailable) {
                detailTextLabel.text = [DeviceUtils statusAsStringFor:eachItem.device status:eachItem.status];
                detailTextLabel.textColor = [UIColor appBlue];
            } else {
                detailTextLabel.text = NSLocalizedString(@"default", @"");
            }
        } else {
            cell.imageView.image = nil;
            cell.textLabel.text = [XXStringUtils emptyString];
            detailTextLabel.text = NSLocalizedString(@"default", @"");
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.timingTask.isSystemTask) {
        if(!(indexPath.section == 0 && indexPath.row == 1)) {
            [tblTimerTaskPlans deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            TextViewController *textViewController = [[TextViewController alloc] init];
            textViewController.delegate = self;
            textViewController.txtDescription = NSLocalizedString(@"new_plan_name", @"");
            textViewController.defaultValue = self.timingTask.name;
            [self presentViewController:textViewController animated:YES completion:^{}];
        } else if(indexPath.row == 1) {
            TimingTaskScheduleDateEditViewController *datePickerViewController = [[TimingTaskScheduleDateEditViewController alloc] initWithTimingTasks:self.timingTask];
            [self presentViewController:datePickerViewController animated:YES completion:^{}];
        }
    } else if(indexPath.section == 1) {
        TimingTaskExecutionItem *executeItem = [self.timingTask.timingTaskExecutionItems objectAtIndex:indexPath.row];
        NSArray *operations = [DeviceUtils operationsListFor:executeItem.device];
        if(operations != nil && operations.count > 0) {
            XXActionSheet *actionSheet = [[XXActionSheet alloc] init];
            [actionSheet setParameter:operations forKey:@"deviceOperations"];
            [actionSheet setParameter:executeItem forKey:@"executeItem"];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            actionSheet.title = NSLocalizedString(@"please_select", @"");
            actionSheet.delegate = self;
            for(int i=0; i<operations.count; i++) {
                DeviceOperationItem *item = [operations objectAtIndex:i];
                if(executeItem.status == item.deviceState) {
                    actionSheet.destructiveButtonIndex = i;
                }
                [actionSheet addButtonWithTitle:item.displayName];
            }
            
            int defaultValueIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"default", @"")];
            if(executeItem.status == DEFAULT_STATUS) {
                actionSheet.destructiveButtonIndex = defaultValueIndex;
            }
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"")];
            [actionSheet showInView:self.view];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet isKindOfClass:[XXActionSheet class]]) {
        XXActionSheet *aSheet = (XXActionSheet *)actionSheet;
        NSArray *operations = [aSheet parameterForKey:@"deviceOperations"];
        TimingTaskExecutionItem *executeItem = [aSheet parameterForKey:@"executeItem"];
        if(buttonIndex < operations.count) {
            DeviceOperationItem *item = [operations objectAtIndex:buttonIndex];
#ifdef DEBUG
            NSLog(@"[%@] - [%@]", item.displayName, item.commandString);
#endif
            executeItem.status = item.deviceState;
            executeItem.executionCommandString = item.commandString;
            [tblTimerTaskPlans reloadData];
        } else if(buttonIndex == operations.count) {
            executeItem.status = DEFAULT_STATUS;
            executeItem.executionCommandString = [XXStringUtils emptyString];
            [tblTimerTaskPlans reloadData];
        }
    }
}

@end
