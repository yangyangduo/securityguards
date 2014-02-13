//
//  UnitDetailsViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitDetailsViewController.h"
#import "CameraInfoModifyViewController.h"
#import "DeviceUtils.h"
#import "DeviceService.h"

@interface UnitDetailsViewController ()

@end

@implementation UnitDetailsViewController {
    UITableView *tblDevices;
    
    NSArray *_devices_;
}

@synthesize unit = _unit_;

- (id)initWithUnit:(Unit *)unit {
    self = [super init];
    if(self) {
        self.unit = unit;
        Zone *zone = [self.unit findSlaveZone];
        if(zone != nil) {
            _devices_ = zone.devices;
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
    if(self.unit == nil || _devices_.count == 0) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    return _devices_.count;
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
        
        UILabel *detailTextLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
        detailTextLabel2.center = CGPointMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 230 : 215, cell.contentView.bounds.size.height / 2);
        detailTextLabel2.textAlignment = NSTextAlignmentRight;
        detailTextLabel2.backgroundColor = [UIColor clearColor];
        detailTextLabel2.tag = 888;
        detailTextLabel2.font = [UIFont systemFontOfSize:16.f];
        [cell.contentView addSubview:detailTextLabel2];
    }
    
    UILabel *detailTextLabel2 = (UILabel *)[cell viewWithTag:888];
    
    if(indexPath.section == 0) {
        cell.textLabel.text = self.unit != nil ? self.unit.name : [XXStringUtils emptyString];
        cell.detailTextLabel.text = NSLocalizedString(@"change_unit_name", @"");
    } else {

        Device *device = [_devices_ objectAtIndex:indexPath.row];
        cell.textLabel.text = device.name;
        
        if(device.isOnline) {
            detailTextLabel2.textColor = [UIColor lightGrayColor];
        } else {
            detailTextLabel2.textColor = [UIColor redColor];
        }
        
        if(device.isCamera) {
            cell.detailTextLabel.text = NSLocalizedString(@"modify_camera_info", @"");
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"change_plan_name", @"");
        }

        if(device.isCamera && device.isOnline) {
            detailTextLabel2.text = device.status == 0 ?
                NSLocalizedString(@"owner_access_short", @"") : NSLocalizedString(@"all_access_short", @"");
        } else {
            detailTextLabel2.text = [DeviceUtils stateAsString:device.state];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UnitRenameViewController *unitRenameViewController = [[UnitRenameViewController alloc] initWithUnit:self.unit];
        [self presentViewController:unitRenameViewController animated:YES completion:^{}];
    } else {
        Device *device = [_devices_ objectAtIndex:indexPath.row];
        if(device.isCamera) {
            CameraInfoModifyViewController *cameraMofifyViewController = [[CameraInfoModifyViewController alloc] initWithCameraDevice:device];
            
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
        if([device.name isEqualToString:newText] || device == nil) {
            [textView popupViewController];
        } else {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
            [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
            DeviceService *service = [[DeviceService alloc] init];
            // '-1000' tell the service that we doesn't need to update the property of 'status' for device
            [service updateDeviceName:newText status:-1000 type:-1000 for:device success:@selector(updateDeviceNameOrStatusSuccess:) failed:@selector(updateDeviceNameOrStatusFailed:) target:self callback:textView];
        }
    }
}

#pragma mark -
#pragma mark Service Call Back

- (void)updateDeviceNameOrStatusSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_json_ = [JsonUtils createDictionaryFromJson:resp.body];
        if(_json_ != nil) {
            int result = [_json_ intForKey:@"i"];
            if(result == 1) {
                [tblDevices reloadData];
                TextViewController *textView = (TextViewController *)resp.callbackObject;
                Device *device = [self.unit deviceForId:textView.identifier];
                if(device != nil) {
                    device.name = textView.value;
                }
                [textView popupViewController];
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
            } else if(result == -2) {
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_bind", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
            } else {
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"system_error", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
            }
            return;
        }
    }
    [self updateDeviceNameOrStatusFailed:resp];
}

- (void)updateDeviceNameOrStatusFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 1004) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
    } else if(abs(resp.statusCode) == 403) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

@end
