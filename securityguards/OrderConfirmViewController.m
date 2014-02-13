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

@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController {
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
    
    [self.view addSubview:btnSubmitOrder];
}

#pragma mark -
#pragma mark UI Events

- (void)confirmAndSubmitOrder:(id)sender {
    ShoppingCompletedViewController *shoppingCompletedViewController = [[ShoppingCompletedViewController alloc] init];
    [self.navigationController pushViewController:shoppingCompletedViewController animated:YES];
}

@end
