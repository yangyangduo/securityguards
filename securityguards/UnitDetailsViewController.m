//
//  UnitDetailsViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitDetailsViewController.h"
#import "CameraInfoModifyViewController.h"

@interface UnitDetailsViewController ()

@end

@implementation UnitDetailsViewController {
    UITableView *tblDevices;
}

@synthesize unit = _unit_;

- (id)initWithUnit:(Unit *)unit {
    self = [super init];
    if(self) {
        self.unit = unit;
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

- (void)viewWillAppear:(BOOL)animated {
    if(tblDevices != nil) {
        [tblDevices reloadData];
    }
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    
    self.topbarView.title = NSLocalizedString(@"device_management", @"");
    
    tblDevices = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    tblDevices.backgroundView = nil;
    tblDevices.delegate = self;
    tblDevices.dataSource = self;
    
    [self.view addSubview:tblDevices];
}

#pragma mark -
#pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.unit == 0 || self.unit.devices.count == 0) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    return self.unit.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appDarkGray];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = self.unit != nil ? self.unit.name : [XXStringUtils emptyString];
        cell.detailTextLabel.text = NSLocalizedString(@"change_unit_name", @"");
    } else {
        Device *device = [self.unit.devices objectAtIndex:indexPath.row];
        cell.textLabel.text = device.name;
        if(device.isCamera) {
            cell.detailTextLabel.text = NSLocalizedString(@"modify_camera_info", @"");
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"change_plan_name", @"");
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UnitRenameViewController *unitRenameViewController = [[UnitRenameViewController alloc] initWithUnit:self.unit];
        [self presentViewController:unitRenameViewController animated:YES completion:^{}];
    } else {
        Device *device = [self.unit.devices objectAtIndex:indexPath.row];
        if(device.isCamera) {
            CameraInfoModifyViewController *cameraMofifyViewController = [[CameraInfoModifyViewController alloc] init];
            
            [self.navigationController pushViewController:cameraMofifyViewController animated:YES];
        } else {
            TextViewController *txtViewController = [[TextViewController alloc] init];
            txtViewController.identifier = device.identifier;
            txtViewController.delegate = self;
            txtViewController.txtDescription = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"change_name", @"")];
            txtViewController.defaultValue = device.name;
            [self presentViewController:txtViewController animated:YES completion:^{}];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Text View

- (void)textView:(TextViewController *)textView newText:(NSString *)newText {
    if([XXStringUtils isBlank:newText]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"timing_tasks_plan_name_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    } else {
        Device *device = [self.unit deviceForId:textView.identifier];
        if([device.name isEqualToString:newText]) {
            [textView popupViewController];
        } else {
            NSLog(newText);
        }
    }
}

@end
