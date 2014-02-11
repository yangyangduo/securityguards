//
//  CameraInfoModifyViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CameraInfoModifyViewController.h"

@interface CameraInfoModifyViewController ()

@end

@implementation CameraInfoModifyViewController {
    UITableView *tblCameraInfo;
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

#pragma mark -
#pragma mark Table View 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? NSLocalizedString(@"change_camera_name", @"") : NSLocalizedString(@"camera_protection", @"");
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
        cell.textLabel.text = self.cameraDevice != nil ? self.cameraDevice.name : [XXStringUtils emptyString];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"owner_access", @"");
            if(self.cameraDevice != nil) {
                if(self.cameraDevice.status == 0) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        } else {
            if(self.cameraDevice.status == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = NSLocalizedString(@"all_access", @"");
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        NSIndexPath *orginIndexPath = [NSIndexPath indexPathForRow:indexPath.row == 0 ? 1 : 0 inSection:1];
        UITableViewCell *orginCell = [tableView cellForRowAtIndexPath:orginIndexPath];
        orginCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        TextViewController *modifyCameraNameViewController = [[TextViewController alloc] init];
        modifyCameraNameViewController.delegate = self;
        modifyCameraNameViewController.txtDescription = NSLocalizedString(@"new_plan_name", @"");
        modifyCameraNameViewController.defaultValue = self.cameraDevice.name;
        [self presentViewController:modifyCameraNameViewController animated:YES completion:^{}];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Getter and Setters

- (void)setCameraDevice:(Device *)cameraDevice {
    if(cameraDevice == nil) {
        _cameraDevice_ = nil;
        return;
    }
    if(!cameraDevice.isCamera) {
        cameraDevice = nil;
    }
    _cameraDevice_ = cameraDevice;
}

#pragma mark -
#pragma mark Text View

- (void)textView:(TextViewController *)textView newText:(NSString *)newText {
    if([XXStringUtils isBlank:newText]) {
        
    } else if([self.cameraDevice.name isEqualToString:newText]) {
        [textView popupViewController];
    } else {
        
    }
}

@end
