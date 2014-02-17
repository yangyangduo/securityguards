//
//  OrderConfirmViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "ShoppingCompletedViewController.h"
#import "ShoppingStateView.h"
#import "ShoppingCart.h"

@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController {
    UITableView *tblOrder;
    UIButton *btnSubmitOrder;
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
    self.topbarView.title = NSLocalizedString(@"shopping_online", @"");
    ShoppingStateView *shoppingStateView = [[ShoppingStateView alloc] initWithPoint:CGPointMake(0, self.topbarView.bounds.size.height) shoppingState:ShoppingStateConfirmOrder];
    [self.view addSubview:shoppingStateView];
    
    btnSubmitOrder = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [btnSubmitOrder addTarget:self action:@selector(confirmAndSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
    btnSubmitOrder.backgroundColor = [UIColor appBlue];
    [btnSubmitOrder setTitle:NSLocalizedString(@"confirm_submit_order", @"") forState:UIControlStateNormal];
    
    tblOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, shoppingStateView.frame.origin.y + shoppingStateView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - shoppingStateView.bounds.size.height - btnSubmitOrder.bounds.size.height) style:UITableViewStyleGrouped];
    tblOrder.backgroundView = nil;
    tblOrder.backgroundColor = [UIColor whiteColor];
    tblOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblOrder.delegate = self;
    tblOrder.dataSource = self;
    [self.view addSubview:tblOrder];
    
    [self.view addSubview:btnSubmitOrder];
}

#pragma mark -
#pragma mark UI Events

- (void)confirmAndSubmitOrder:(id)sender {
    ShoppingCompletedViewController *shoppingCompletedViewController = [[ShoppingCompletedViewController alloc] init];
    [self.navigationController pushViewController:shoppingCompletedViewController animated:YES];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 4;
    return [ShoppingCart shoppingCart].shoppingEntries == nil ? 0 : [ShoppingCart shoppingCart].shoppingEntries.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *imageName = [XXStringUtils emptyString];
    NSString *title = [XXStringUtils emptyString];
    
    if(section == 0) {
        imageName = @"contact";
        title = NSLocalizedString(@"contact_info", @"");
    } else {
        imageName = @"shopping_cart";
        title = NSLocalizedString(@"my_shopping_cart", @"");
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, section== 0 ?35 : 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 59.f / 2, 47.f / 2)];
    imgView.center = CGPointMake(imgView.center.x, 5 + 30 / 2);
    imgView.image = [UIImage imageNamed:imageName];
    [headerView addSubview:imgView];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.y + imgView.frame.size.width + 15, 5, 150, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = title;
    [headerView addSubview:lblTitle];
    
    if(section == 1) {
        UIImageView *imgGrayLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.bounds.size.width, 1)];
        imgGrayLine.image = [UIImage imageNamed:@"dotline_gray"];
        [headerView addSubview:imgGrayLine];
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0) {
        
    } else {
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 35 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44 : 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"cellIdentifier1";
    static NSString *cellIdentifier2 = @"cellIdentifier2";
    UITableViewCell *cell = [tblOrder dequeueReusableCellWithIdentifier:indexPath.section == 0 ? cellIdentifier1 : cellIdentifier2];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        cell.textLabel.font = [UIFont systemFontOfSize:13.f];
        
        if(indexPath.section == 0) {
            cell.backgroundView.backgroundColor = [UIColor appDarkGray];
            cell.selectedBackgroundView.backgroundColor = [UIColor appDarkDarkGray];
            
            UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 7, 195, 30)];
            detailTextLabel.tag = 9999;
            detailTextLabel.font = [UIFont systemFontOfSize:13.f];
            detailTextLabel.textColor = [UIColor lightGrayColor];
            detailTextLabel.backgroundColor = [UIColor clearColor];
            detailTextLabel.text = @"度搜积分就豆腐机第三方第三方度搜房间是丹佛度积分搜";
            [cell addSubview:detailTextLabel];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
        } else {
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView.backgroundColor = [UIColor appGray];
            
            UILabel *lblMerchandiseDetail = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, 120, 30)];
            lblMerchandiseDetail.backgroundColor = [UIColor clearColor];
            lblMerchandiseDetail.font = [UIFont systemFontOfSize:13.f];
            lblMerchandiseDetail.textAlignment = NSTextAlignmentCenter;
            lblMerchandiseDetail.tag = 8888;
            lblMerchandiseDetail.text = @"高配版, 白色 X 20";
            
            UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 60, 30)];
            lblPrice.font = [UIFont boldSystemFontOfSize:14.f];
            lblPrice.textAlignment = NSTextAlignmentRight;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor orangeColor];
            lblPrice.text = @"￥12222";
            lblPrice.tag = 7777;
            
            [cell addSubview:lblPrice];
            [cell addSubview:lblMerchandiseDetail];
        }
    }
    
    if(indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"contact", @"")];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"contact_phone", @"")];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"delivery_address", @"")];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"remark", @"")];
                break;
            default:
                break;
        }
    } else {
        ShoppingEntry *entry = [[ShoppingCart shoppingCart].shoppingEntries objectAtIndex:indexPath.row];
        cell.textLabel.text = entry.merchandise.name;
    }
    
    return cell;
}


@end
