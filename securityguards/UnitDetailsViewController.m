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
#import "SMNetworkTool.h"

@interface UnitDetailsViewController ()

@end

@implementation UnitDetailsViewController {
    UIView *unitInfoDetailsView;
    UILabel *lblWifiName;
    UILabel *lblLocalIp;
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
    
    unitInfoDetailsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, 68)];
    unitInfoDetailsView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgWifi = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 31, 26)];
    imgWifi.image = [UIImage imageNamed:@"icon_wifi"];
    [unitInfoDetailsView addSubview:imgWifi];
    
    UIImageView *imgLocalIp = [[UIImageView alloc] initWithFrame:CGRectMake(10, 38, 31, 26)];
    imgLocalIp.image = [UIImage imageNamed:@"icon_local_ip"];
    [unitInfoDetailsView addSubview:imgLocalIp];
    
    UILabel *lblWifiTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, 80, 26)];
    lblWifiTitle.backgroundColor = [UIColor clearColor];
    lblWifiTitle.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"wifi_name", @"")];
    [unitInfoDetailsView addSubview:lblWifiTitle];
    
    lblWifiName = [[UILabel alloc] initWithFrame:CGRectMake(140, 4, 165, 26)];
    NSString *currentWifi = [SMNetworkTool ssidForCurrentWifi];
    if([XXStringUtils isBlank:currentWifi]) {
        lblWifiName.text = NSLocalizedString(@"wifi_disconnectted", @"");
    } else {
        lblWifiName.text = currentWifi;
    }
    lblWifiName.font = [UIFont systemFontOfSize:14.f];
    lblWifiName.textColor = [UIColor lightGrayColor];
    lblWifiName.textAlignment = NSTextAlignmentRight;
    lblWifiName.backgroundColor = [UIColor clearColor];
    [unitInfoDetailsView addSubview:lblWifiName];
    
    UILabel *lblLocalIpTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 38, 80, 26)];
    lblLocalIpTitle.backgroundColor = [UIColor clearColor];
    lblLocalIpTitle.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"internal_ip", @"")];
    [unitInfoDetailsView addSubview:lblLocalIpTitle];
    
    lblLocalIp = [[UILabel alloc] initWithFrame:CGRectMake(140, 38, 165, 26)];
    lblLocalIp.text = self.unit != nil ? self.unit.localIP : [XXStringUtils emptyString];
    lblLocalIp.font = [UIFont systemFontOfSize:14.f];
    lblLocalIp.textColor = [UIColor lightGrayColor];
    lblLocalIp.textAlignment = NSTextAlignmentRight;
    lblLocalIp.backgroundColor = [UIColor clearColor];
    [unitInfoDetailsView addSubview:lblLocalIp];
    
    [self.view addSubview:unitInfoDetailsView];
    
    tblDevices = [[UITableView alloc] initWithFrame:CGRectMake(0, unitInfoDetailsView.frame.origin.y + unitInfoDetailsView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
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
        if(self.unit != nil) {
            // 这种糟糕的判断方式 只能怪主控那边 ！！！
            if(self.unit.isOnline) {
                detailTextLabel2.text = NSLocalizedString(@"device_online", @"");
                detailTextLabel2.textColor = [UIColor lightGrayColor];
            } else {
                detailTextLabel2.text = NSLocalizedString(@"device_offline", @"");
                detailTextLabel2.textColor = [UIColor redColor];
            }
        } else {
            detailTextLabel2.text = [XXStringUtils emptyString];
        }
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
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"timing_tasks_plan_name_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    } else if(newText.length > 8) {
        [[XXAlertView currentAlertView] setMessage:@"名字太长" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    } else {
        Device *device = [self.unit deviceForId:textView.identifier];
        if([device.name isEqualToString:newText] || device == nil) {
            [textView popupViewController];
        } else {
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
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
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
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
    [self updateDeviceNameOrStatusFailed:resp];
}

- (void)updateDeviceNameOrStatusFailed:(RestResponse *)resp {
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

@end
