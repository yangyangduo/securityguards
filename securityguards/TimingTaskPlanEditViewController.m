//
//  TimingTaskPlanEditViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTaskPlanEditViewController.h"
#import "TimingTaskScheduleDateEditViewController.h"
#import "TextViewController.h"

@interface TimingTaskPlanEditViewController ()

@end

@implementation TimingTaskPlanEditViewController {
    UITableView *tblTimerTaskPlans;
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

- (instancetype)initWithUnit:(Unit *)unit {
    self = [super init];
    if(self) {
        _unit_ = unit;
    }
    return self;
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = self.unit == nil ? NSLocalizedString(@"task_timer_title", @"") : self.unit.name;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, 120)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.minuteInterval = 10;
    [self.view addSubview:datePicker];
    
    tblTimerTaskPlans = [[UITableView alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y + datePicker.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - datePicker.bounds.size.height) style:UITableViewStyleGrouped];
    tblTimerTaskPlans.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblTimerTaskPlans.delegate = self;
    tblTimerTaskPlans.dataSource = self;
    
    [self.view addSubview:tblTimerTaskPlans];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 2;
    return 3;
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
            cell.textLabel.text = @"定时执行";
        } else if(indexPath.row == 1) {
            cell.detailTextLabel.text = NSLocalizedString(@"change_schedule_date", @"");
            cell.textLabel.text = @"每周一、二、三、四、五、六、日";
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
        
        if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor appDarkGray];
        } else {
            cell.backgroundView.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor appDarkGray];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"icon_power"];
        cell.textLabel.text = @"电源";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            TextViewController *textViewController = [[TextViewController alloc] init];
            textViewController.txtDescription = NSLocalizedString(@"new_plan_name", @"");
            textViewController.defaultValue = @"定时执行";
            [self presentViewController:textViewController animated:YES completion:^{}];
        } else if(indexPath.row == 1) {
            int j = (1 | (1 << 1) | (1 << 2) | (1 << 5));
            TimingTaskScheduleDateEditViewController *datePickerViewController = [[TimingTaskScheduleDateEditViewController alloc] initWithBitScheduleDate:j isScheduleOnce:YES];
            [self presentViewController:datePickerViewController animated:YES completion:^{}];
        }
    } else if(indexPath.section == 1) {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
