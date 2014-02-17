//
//  ShoppingViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingViewController.h"
#import "OrderConfirmViewController.h"
#import "ShoppingStateView.h"
#import "MerchandiseCell.h"
#import "ShoppingService.h"
#import "ShoppingCart.h"
#import <UIImageView+WebCache.h>

@interface ShoppingViewController ()

@end

@implementation ShoppingViewController {
    UITableView *tblMerchandises;
    NSMutableArray *merchandises;
    
    UILabel *lblTotalPrice;
    UIView *bottomBar;
    UIButton *btnSubmit;
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
    ShoppingStateView *shoppingStateView = [[ShoppingStateView alloc] initWithPoint:CGPointMake(0, self.topbarView.bounds.size.height) shoppingState:ShoppingStateSelecting];
    [self.view addSubview:shoppingStateView];
    
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    bottomBar.backgroundColor = [UIColor appDarkDarkGray];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 64.f / 2, 70.f / 2)];
    imgView.image = [UIImage imageNamed:@"shopping_cart"];
    [bottomBar addSubview:imgView];
    
    lblTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(58, 2, 115, 40)];
    lblTotalPrice.backgroundColor = [UIColor clearColor];
    lblTotalPrice.textAlignment = NSTextAlignmentLeft;
    lblTotalPrice.font = [UIFont systemFontOfSize:24.f];
    lblTotalPrice.textColor = [UIColor redColor];
    [self calcShoppingCartTotalPriceForDisplay];
    [bottomBar addSubview:lblTotalPrice];
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(180, 0, 140, 44)];
    [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    btnSubmit.backgroundColor = [UIColor appBlue];
    [bottomBar addSubview:btnSubmit];
    
    [self.view addSubview:bottomBar];
    
    tblMerchandises = [[UITableView alloc] initWithFrame:CGRectMake(0, shoppingStateView.frame.origin.y + shoppingStateView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height - shoppingStateView.bounds.size.height - bottomBar.bounds.size.height) style:UITableViewStylePlain];
    tblMerchandises.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblMerchandises.delegate = self;
    tblMerchandises.dataSource = self;
    [self.view addSubview:tblMerchandises];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tblMerchandises.bounds.size.height, tblMerchandises.frame.size.width, tblMerchandises.bounds.size.height) arrowImageName:@"grayArrow" textColor:[UIColor lightGrayColor]];
    _refreshHeaderView.backgroundColor = [UIColor whiteColor];
    _refreshHeaderView.delegate = self;
    [tblMerchandises addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)getProductsSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_json_ = [JsonUtils createDictionaryFromJson:resp.body];
        int result = [_json_ intForKey:@"i"];
        if(result == 1) {
            NSArray *_m_ = [_json_ arrayForKey:@"m"];
            if(merchandises == nil) {
                merchandises = [NSMutableArray array];
            } else {
                [merchandises removeAllObjects];
            }
            if(_m_ != nil) {
                for(int i=0; i<_m_.count; i++) {
                    [merchandises addObject:[[Merchandise alloc] initWithJson:[_m_ objectAtIndex:i]]];
                }
            }
            [tblMerchandises reloadData];
            return;
        }
    }
    [self getProductsFailed:resp];
}

- (void)getProductsFailed:(RestResponse *)resp {
    NSLog(@"get products failed, code is %d", resp.statusCode);
}

- (void)autoTriggerRefresh {
    [tblMerchandises setContentOffset:CGPointMake(0, -70) animated:YES];
    double delayInSeconds = 0.4f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshHeaderView egoRefreshScrollViewDidScroll:tblMerchandises];
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:tblMerchandises];
    });
}

- (void)viewDidAppear:(BOOL)animated {
//    [self autoTriggerRefresh];
}

#pragma mark -
#pragma mark UI Events

- (void)btnSubmitPressed:(id)sender {
    OrderConfirmViewController *orderConfirmViewController = [[OrderConfirmViewController alloc] init];
    [self.navigationController pushViewController:orderConfirmViewController animated:YES];
}

#pragma mark -
#pragma mark Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MerchandiseCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return merchandises == nil ? 0 : merchandises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    MerchandiseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MerchandiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.merchandise = [merchandises objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MerchandiseDetailSelectView *selectView = [[MerchandiseDetailSelectView alloc] initWithMerchandise:[merchandises objectAtIndex:indexPath.row]];
    selectView.delegate = self;
    [selectView showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)calcShoppingCartTotalPriceForDisplay {
    lblTotalPrice.text = [NSString stringWithFormat:@"%d %@", (int)[ShoppingCart shoppingCart].totalPrice, NSLocalizedString(@"yuan", @"")];
}

#pragma mark -
#pragma mark Merchandise Detail Select View Delegate

- (void)merchandiseDetailSelectView:(MerchandiseDetailSelectView *)merchandiseDetailSelectView willDismissedWithState:(MerchandiseDetailSelectViewDismissedBy)dismissedBy {
    if(dismissedBy == MerchandiseDetailSelectViewDismissedByConfirmed) {
        if(tblMerchandises != nil) {
            [tblMerchandises reloadData];
        }
        [self calcShoppingCartTotalPriceForDisplay];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
    ShoppingService *service = [[ShoppingService alloc] init];
    [service getProductsSuccess:@selector(getProductsSuccess:) failed:@selector(getProductsFailed:) target:self callback:nil];
	_reloading = YES;
}

- (void)doneLoadingTableViewData {
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tblMerchandises];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
