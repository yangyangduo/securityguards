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
}

@synthesize bitScheduleDates = _bitScheduleDates_;
@synthesize isScheduleOnce = _isScheduleOnce_;

- (instancetype)initWithBitScheduleDate:(int)bitScheduleDates isScheduleOnce:(BOOL)isScheduleOnce {
    self = [super init];
    if(self) {
        _isScheduleOnce_ = isScheduleOnce;
        _bitScheduleDates_ = bitScheduleDates;
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
    
    tblScheduleDates = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    
    tblScheduleDates.delegate = self;
    tblScheduleDates.dataSource = self;
    
    [self.view addSubview:tblScheduleDates];
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
        cell.accessoryType = self.isScheduleOnce ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        int bitPosition = indexPath.row;
        BOOL configured = (self.bitScheduleDates & (1 << bitPosition)) == 1 << bitPosition;
        cell.accessoryType = configured ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0) {
        self.isScheduleOnce = !self.isScheduleOnce;
        cell.accessoryType = self.isScheduleOnce ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        int bitPosition = indexPath.row;
        int bitConfigItem = 1 << bitPosition;
        BOOL configured = (self.bitScheduleDates & bitConfigItem) == bitConfigItem;
        if(configured) {
            // remove this config item from bit configs
            self.bitScheduleDates = ~(~self.bitScheduleDates | bitConfigItem);
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            // add this config item from bit configs
            self.bitScheduleDates |= bitConfigItem;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
