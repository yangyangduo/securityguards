//
//  CameraInfoModifyViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CameraInfoModifyViewController.h"
#import "DeviceService.h"
#import "BlueButton.h"

@interface CameraInfoModifyViewController ()

@end

@implementation CameraInfoModifyViewController {
    UITableView *tblCameraInfo;
    
    NSString *cameraName;
    
    int status;
    int type;
}

@synthesize cameraDevice = _cameraDevice_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithCameraDevice:(Device *)cameraDevice {
    self = [super init];
    if(self) {
        self.cameraDevice = cameraDevice;
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
    
    tblCameraInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    tblCameraInfo.backgroundView = nil;
    tblCameraInfo.delegate = self;
    tblCameraInfo.dataSource = self;
    
    [self.view addSubview:tblCameraInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(tblCameraInfo != nil) {
        [tblCameraInfo reloadData];
    }
}

#pragma mark -
#pragma mark Table View 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return NSLocalizedString(@"change_camera_name", @"");
    } else if(section == 1) {
        return NSLocalizedString(@"camera_protection", @"");
    } else {
        return NSLocalizedString(@"install", @"");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section != 2) return 0;
    return 60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *btnSubmit = [BlueButton blueButtonWithPoint:CGPointMake(0, 20) resize:CGSizeMake(300, 40)];
        btnSubmit.center = CGPointMake(self.view.center.x, btnSubmit.center.y);
        [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
        [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
        [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
        [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnSubmit setTitle:NSLocalizedString(@"determine", @"") forState:UIControlStateNormal];
        [footerView addSubview:btnSubmit];
        
        return footerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appDarkDarkGray];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = cameraName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"owner_access", @"");
            if(self.cameraDevice != nil) {
                if(status == 0) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.textLabel.text = NSLocalizedString(@"all_access", @"");
            if(self.cameraDevice != nil) {
                if(status == 1) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else {
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"install_tips", @"");
            if(self.cameraDevice != nil) {
                if(type == 0) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.textLabel.text = NSLocalizedString(@"reverse_install_tips", @"");
            if(self.cameraDevice != nil) {
                if(type == 1) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 || indexPath.section == 2) {
        NSIndexPath *orginIndexPath = [NSIndexPath indexPathForRow:indexPath.row == 0 ? 1 : 0 inSection:indexPath.section];
        UITableViewCell *orginCell = [tableView cellForRowAtIndexPath:orginIndexPath];
        orginCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(indexPath.section == 1) {
            status = indexPath.row;
        } else if(indexPath.section == 2) {
            type = indexPath.row;
        }
    } else {
        TextViewController *modifyCameraNameViewController = [[TextViewController alloc] init];
        modifyCameraNameViewController.delegate = self;
        modifyCameraNameViewController.txtDescription = NSLocalizedString(@"new_plan_name", @"");
        modifyCameraNameViewController.defaultValue = cameraName;
        [self presentViewController:modifyCameraNameViewController animated:YES completion:^{}];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Getter and Setters

- (void)setCameraDevice:(Device *)cameraDevice {
    if(cameraDevice == nil) {
        _cameraDevice_ = nil;
        cameraName = [XXStringUtils emptyString];
        status = 1;
        return;
    }
    if(!cameraDevice.isCamera) {
        cameraDevice = nil;
    }
    _cameraDevice_ = cameraDevice;
    cameraName = _cameraDevice_.name;
    status = _cameraDevice_.status;
    type = _cameraDevice_.type;
}

#pragma mark -
#pragma mark Text View

- (void)textView:(TextViewController *)textView newText:(NSString *)newText {
    if([XXStringUtils isBlank:newText]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"timing_tasks_plan_name_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    } else if([self.cameraDevice.name isEqualToString:newText]) {
        [textView popupViewController];
    } else {
        cameraName = newText;
        [textView popupViewController];
    }
}

#pragma mark -
#pragma mark UI Events

- (void)btnSubmitPressed:(id)sender {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    DeviceService *service = [[DeviceService alloc] init];
    [service updateDeviceName:cameraName status:status type:type for:self.cameraDevice success:@selector(updateDeviceNameOrStatusSuccess:) failed:@selector(updateDeviceNameOrStatusFailed:) target:self callback:nil];
}

- (void)updateDeviceNameOrStatusSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_json_ = [JsonUtils createDictionaryFromJson:resp.body];
        if(_json_ != nil) {
            int result = [_json_ intForKey:@"i"];
            if(result == 1) {
                self.cameraDevice.name = cameraName;
                self.cameraDevice.status = status;
                self.cameraDevice.type = type;
                [self popupViewController];
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
