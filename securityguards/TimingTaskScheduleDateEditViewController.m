//
//  TimingTaskScheduleDateEditViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/23/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TimingTaskScheduleDateEditViewController.h"
#import "ChineseUtils.h"

@interface TimingTaskScheduleDateEditViewController ()

@end

@implementation TimingTaskScheduleDateEditViewController {
    UITableView *tblScheduleDates;
    
    BOOL _isScheduleOnce_;
    int _scheduleDates_;
}

@synthesize timingTask = _timingTask_;

- (instancetype)initWithTimingTasks:(TimingTask *)timingTask {
    self = [super init];
    if(self) {
        _timingTask_ = timingTask;
        if(_timingTask_ != nil) {
            _isScheduleOnce_ = _timingTask_.scheduleMode == TaskScheduleModeNoRepeat;
            _scheduleDates_ = _timingTask_.scheduleDate;
        } else {
            _isScheduleOnce_ = YES;
            _scheduleDates_ = 0;
        }
    }
    return self;
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

- (void)popupViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)initUI {
    [super initUI];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 88 / 2), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88 / 2, 88 / 2)];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"icon_save"] forState:UIControlStateNormal];
    [btnRight setTitle:[NSString stringWithFormat:@"  %@", NSLocalizedString(@"determine", @"")] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView addSubview:btnRight];
    
    tblScheduleDates = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    
    tblScheduleDates.delegate = self;
    tblScheduleDates.dataSource = self;
    
    [self.view addSubview:tblScheduleDates];
}

- (void)save:(id)sender {
    if(self.timingTask != nil) {
        self.timingTask.scheduleDate = _scheduleDates_;
        self.timingTask.scheduleMode = _isScheduleOnce_ ? TaskScheduleModeNoRepeat : TaskScheduleModeRepeat;
    }
    [self popupViewController];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appGray];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    // set title label
    if(indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"schedule_once", @"");
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"week", @""), [ChineseUtils chineseWeekForInt:indexPath.row + 1]];
    }
    
    if(indexPath.section == 0) {
        cell.accessoryType = _isScheduleOnce_ ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        int bitPosition = indexPath.row;
        BOOL configured = (_scheduleDates_ & (1 << bitPosition)) == 1 << bitPosition;
        cell.accessoryType = configured ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0) {
        if(_isScheduleOnce_ || [self scheduleDatesIsOnlyOne]) {
             _isScheduleOnce_ = !_isScheduleOnce_;
            cell.accessoryType = _isScheduleOnce_ ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        } else {
            TaskScheduleDate firstScheduleDate = 0;
            [self scheduleDatesIsOnlyOne:&firstScheduleDate];
            _scheduleDates_ = firstScheduleDate;
            _isScheduleOnce_ = !_isScheduleOnce_;
            [tblScheduleDates reloadData];
            return;
        }
    } else {
        int bitPosition = indexPath.row;
        int bitConfigItem = 1 << bitPosition;
        BOOL configured = (_scheduleDates_ & bitConfigItem) == bitConfigItem;
        
        // multi selected must selected at leat one
        if(!_isScheduleOnce_
            && [self scheduleDatesIsOnlyOne]
            && configured) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        
        if(_isScheduleOnce_) {
            if(!configured) {
                _scheduleDates_ = bitConfigItem;
                [tblScheduleDates reloadData];
                return;
            }
        } else {
            if(configured) {
                // remove this config item from bit configs
                _scheduleDates_ = ~(~_scheduleDates_ | bitConfigItem);
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                // add this config item from bit configs
                _scheduleDates_ |= bitConfigItem;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)scheduleDatesIsOnlyOne {
    for(int i=0; i<7; i++) {
        if(_scheduleDates_ == (1 << i)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)scheduleDatesIsOnlyOne:(TaskScheduleDate *)firstScheduleDate {
    BOOL firstScheduleDateWasFound = NO;
    for(int i=0; i<7; i++) {
        if(_scheduleDates_ == (1 << i)) {
            *firstScheduleDate = (1 << i);
            return YES;
        }
        if(!firstScheduleDateWasFound) {
            if((_scheduleDates_ & (1 << i)) == (1 << i)) {
                *firstScheduleDate = (1 << i);
                firstScheduleDateWasFound = YES;
            }
        }
    }
    return NO;
}

@end
