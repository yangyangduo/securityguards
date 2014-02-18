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
#import "ShoppingService.h"
#import "Contact.h"
#import "CheckBox.h"

@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController {
    UITableView *tblOrder;
    UIButton *btnSubmitOrder;
    UILabel *lblTotalPrice;
    CheckBox *checkbox;
    
    Contact *contact;
    
    BOOL contactWasLoaded;
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

- (void)initDefaults {
    [super initDefaults];
    contactWasLoaded = NO;
    contact = [ShoppingCart shoppingCart].contact;
    if(contact == nil) {
        [ShoppingCart shoppingCart].contact = [[Contact alloc] init];
        contact = [ShoppingCart shoppingCart].contact;
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(contactWasLoaded) return;
    ShoppingService *service = [[ShoppingService alloc] init];
    [service getContactInfoSuccess:@selector(getContactSuccess:) failed:@selector(getContactFailed:) target:self callback:nil];
}

#pragma mark -
#pragma mark Service callback

- (void)getContactSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_json_ = [JsonUtils createDictionaryFromJson:resp.body];
        if([_json_ intForKey:@"i"] == 1) {
            NSDictionary *_json_contact_ = [_json_ dictionaryForKey:@"m"];
            if(_json_contact_ != nil) {
                [ShoppingCart shoppingCart].contact = [[Contact alloc] initWithJson:_json_contact_];
            } else {
                [ShoppingCart shoppingCart].contact = [[Contact alloc] init];
            }
            contact = [ShoppingCart shoppingCart].contact;
            [tblOrder reloadData];
            contactWasLoaded = YES;
            return;
        }
    }
    [self getContactFailed:resp];
}

- (void)getContactFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[ORDER CONFIRM VIEW CONTROLLER] Get contact failed, code is %d", resp.statusCode);
#endif
}

- (void)postOrderSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *result = [JsonUtils createDictionaryFromJson:resp.body];
        if(result != nil) {
            if([result intForKey:@"i"] == 1) {
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"order_submitted", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
                
                ShoppingCompletedViewController *shoppingCompletedViewController = [[ShoppingCompletedViewController alloc] init];
                [self.navigationController pushViewController:shoppingCompletedViewController animated:YES];

                [[ShoppingCart shoppingCart] clearShoppingCart];
                return;
            }
        }
    }
    [self postOrderFailed:resp];
}

- (void)postOrderFailed:(RestResponse *)resp {
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

#pragma mark -
#pragma mark UI Events

- (void)confirmAndSubmitOrder:(id)sender {
    if([XXStringUtils isBlank:contact.name]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"contact_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:contact.phoneNumber]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:contact.address]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"address_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
//    、、phone_invalid
    
    NSDictionary *_shopping_info_json = [[ShoppingCart shoppingCart] toDictionary];
    if(_shopping_info_json == nil) {
#ifdef DEBUG
        NSLog(@"[ORDER CONFIRM VIEW CONTROLLER] Post order shopping cart dictionary is empty.");
#endif
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"system_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    NSData *body = [JsonUtils createJsonDataFromDictionary:_shopping_info_json];
    if(body == nil) {
#ifdef DEBUG
        NSLog(@"[ORDER CONFIRM VIEW CONTROLLER] Post order body is empty.");
#endif
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"system_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    ShoppingService *service = [[ShoppingService alloc] init];
    [service postOrder:body success:@selector(postOrderSuccess:) failed:@selector(postOrderFailed:) saveContact:checkbox.selected target:self callback:nil];
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
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 54)];
        if(checkbox == nil) {
            checkbox = [CheckBox checkBoxWithPoint:CGPointMake(10, 0)];
            checkbox.center = CGPointMake(self.view.center.x, checkbox.center.y);
        }
        [footView addSubview:checkbox];
        return footView;
    } else {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
        
        UIImageView *imgGrayLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, self.view.bounds.size.width, 1)];
        imgGrayLine.image = [UIImage imageNamed:@"dotline_gray"];
        [footView addSubview:imgGrayLine];
        
        UILabel *lblTotalPriceDescription = [[UILabel alloc] initWithFrame:CGRectMake(208, 10, 35, 30)];
        lblTotalPriceDescription.font = [UIFont systemFontOfSize:14.f];
        lblTotalPriceDescription.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"total_price", @"")];
        lblTotalPriceDescription.backgroundColor = [UIColor clearColor];
        [footView addSubview:lblTotalPriceDescription];
        
        lblTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(240, 10, 70, 30)];
        lblTotalPrice.backgroundColor = [UIColor clearColor];
        lblTotalPrice.textColor = [UIColor orangeColor];
        lblTotalPrice.textAlignment = NSTextAlignmentRight;
        lblTotalPrice.font = [UIFont boldSystemFontOfSize:14.f];
        lblTotalPrice.text = [NSString stringWithFormat:@"￥%d", (int)[ShoppingCart shoppingCart].totalPrice];
        [footView addSubview:lblTotalPrice];
        
        UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, lblTotalPrice.frame.origin.y + lblTotalPrice.bounds.size.height + 10, 280, 90)];
        lblTips.center = CGPointMake(self.view.center.x, lblTips.center.y);
        lblTips.textColor = [UIColor lightGrayColor];
        lblTips.numberOfLines = 5;
        lblTips.font = [UIFont systemFontOfSize:14.f];
        lblTips.text = NSLocalizedString(@"shopping_completed_tips", @"");
        [footView addSubview:lblTips];
        return footView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 35 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) return 44;
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44 : 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"cellIdentifier1";
    static NSString *cellIdentifier2 = @"cellIdentifier2";
    UITableViewCell *cell = [tblOrder dequeueReusableCellWithIdentifier:indexPath.section == 0 ? cellIdentifier1 : cellIdentifier2];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexPath.section == 0 ? cellIdentifier1 : cellIdentifier2];
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
            [cell addSubview:detailTextLabel];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [cell addSubview:line];
        } else {
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView.backgroundColor = [UIColor appGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lblMerchandiseDetail = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, 120, 30)];
            lblMerchandiseDetail.backgroundColor = [UIColor clearColor];
            lblMerchandiseDetail.font = [UIFont systemFontOfSize:13.f];
            lblMerchandiseDetail.textAlignment = NSTextAlignmentCenter;
            lblMerchandiseDetail.tag = 8888;
            
            UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 60, 30)];
            lblPrice.font = [UIFont boldSystemFontOfSize:14.f];
            lblPrice.textAlignment = NSTextAlignmentRight;
            lblPrice.backgroundColor = [UIColor clearColor];
            lblPrice.textColor = [UIColor orangeColor];
            lblPrice.tag = 7777;
            
            [cell addSubview:lblPrice];
            [cell addSubview:lblMerchandiseDetail];
        }
    }
    
    if(indexPath.section == 0) {
        UILabel *lblDetails = (UILabel *)[cell viewWithTag:9999];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"contact", @"")];
                lblDetails.text = contact == nil ? [XXStringUtils emptyString] : contact.name;
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"contact_phone", @"")];
                lblDetails.text = lblDetails.text = contact == nil ? [XXStringUtils emptyString] : contact.phoneNumber;
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"delivery_address", @"")];
                lblDetails.text = lblDetails.text = contact == nil ? [XXStringUtils emptyString] : contact.address;
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"remark", @"")];
                lblDetails.text = lblDetails.text = contact == nil ? [XXStringUtils emptyString] : contact.remark;
                break;
            default:
                break;
        }
    } else {
        UILabel *lblMerchandiseDetail = (UILabel *)[cell viewWithTag:8888];
        UILabel *lblPrice = (UILabel *)[cell viewWithTag:7777];
        ShoppingEntry *entry = [[ShoppingCart shoppingCart].shoppingEntries objectAtIndex:indexPath.row];
        cell.textLabel.text = entry.merchandise.name;
        lblMerchandiseDetail.text = [entry shoppingEntryDetailsAsString];
        lblPrice.text = [NSString stringWithFormat:@"￥%d", (int)entry.totalPrice];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        TextViewController *textView = nil;
        if(indexPath.row == 1) {
            textView = [[TextViewController alloc] initWithKeyboardType:UIKeyboardTypeNumberPad];
        } else {
            textView = [[TextViewController alloc] init];
        }
        textView.delegate = self;
        textView.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"contact_info", @""), NSLocalizedString(@"modify", @"")];
        if(indexPath.row == 0) {
            textView.identifier = @"c_name";
            textView.defaultValue = contact == nil ? [XXStringUtils emptyString] : contact.name;
            textView.txtDescription = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"contact_name", @"")];
        } else if(indexPath.row == 1) {
            textView.identifier = @"c_phone";
            if(textView.textField != nil) {
                textView.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            textView.defaultValue = contact == nil ? [XXStringUtils emptyString] : contact.phoneNumber;
            textView.txtDescription = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"contact_phone", @"")];
        } else if(indexPath.row == 2) {
            textView.identifier = @"c_address";
            textView.defaultValue = contact == nil ? [XXStringUtils emptyString] : contact.address;
            textView.txtDescription = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"delivery_address", @"")];
        } else {
            textView.identifier = @"c_remark";
            textView.defaultValue = contact == nil ? [XXStringUtils emptyString] : contact.remark;
            textView.txtDescription = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"remark_no_blank", @"")];
        }
        [self presentViewController:textView animated:YES completion:^{ }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textView:(TextViewController *)textView newText:(NSString *)newText {
    if([@"c_name" isEqualToString:textView.identifier]) {
        contact.name = newText;
    } else if([@"c_phone" isEqualToString:textView.identifier]) {
        contact.phoneNumber = newText;
    } else if([@"c_address" isEqualToString:textView.identifier]) {
        contact.address = newText;
    } else if([@"c_remark" isEqualToString:textView.identifier]) {
        contact.remark = newText;
    }
    if(tblOrder != nil) {
        [tblOrder reloadData];
    }
    [textView popupViewController];
}

@end
