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
        cell.textLabel.text = @"摄像头";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"owner_access", @"");
        } else {
            cell.textLabel.text = NSLocalizedString(@"all_access", @"");
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
