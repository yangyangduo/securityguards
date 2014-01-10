//
//  CopyrightViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CopyrightViewController.h"

@interface CopyrightViewController ()

@end

@implementation CopyrightViewController {
    UITableView *tblCopyright;
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
    
    tblCopyright = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height) style:UITableViewStyleGrouped];
    tblCopyright.backgroundColor = [UIColor clearColor];
    tblCopyright.backgroundView = nil;
    tblCopyright.delegate = self;
    tblCopyright.dataSource = self;
    [self.view addSubview:tblCopyright];
    
    self.topbarView.title = NSLocalizedString(@"copyright_drawer_title", @"");
    self.view.backgroundColor = [UIColor appGray];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 389.f / 2, 147.f / 2)];
    imgLogo.center = CGPointMake(self.view.center.x, imgLogo.center.y);
    imgLogo.image = [UIImage imageNamed:@"logo_gold"];
    [headerView addSubview:imgLogo];
    
    UILabel *lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, imgLogo.frame.origin.y + imgLogo.bounds.size.height + 8, 200, 30)];
    lblVersion.backgroundColor = [UIColor clearColor];
    lblVersion.font = [UIFont systemFontOfSize:18.f];
    lblVersion.textColor = [UIColor lightGrayColor];
    lblVersion.text = NSLocalizedString(@"version", @"");
    lblVersion.textAlignment = NSTextAlignmentCenter;
    lblVersion.center = CGPointMake(self.view.center.x, lblVersion.center.y);
    [headerView addSubview:lblVersion];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor appDarkGray];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"版权信息";
            break;
        case 1:
            cell.textLabel.text = @"软件许可使用协议";
            break;
        case 2:
            cell.textLabel.text = @"特别说明";
            break;
        default:
            break;
    }
    
    return cell;
}

@end
