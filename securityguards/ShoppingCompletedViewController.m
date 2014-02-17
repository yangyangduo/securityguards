//
//  ShoppingCompletedViewController.m
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCompletedViewController.h"
#import "ShoppingStateView.h"
#import "BlueButton.h"

@interface ShoppingCompletedViewController ()

@end

@implementation ShoppingCompletedViewController

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
    ShoppingStateView *shoppingStateView = [[ShoppingStateView alloc] initWithPoint:CGPointMake(0, self.topbarView.bounds.size.height) shoppingState:ShoppingStateCompleted];
    [self.view addSubview:shoppingStateView];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, shoppingStateView.frame.origin.y + shoppingStateView.bounds.size.height + 5, 284 / 2, 94 / 2)];
    imgLogo.center = CGPointMake(self.view.center.x, imgLogo.center.y);
    imgLogo.image = [UIImage imageNamed:@"logo_left_drawer"];
    [self.view addSubview:imgLogo];
    
    UIImageView *imgLineBegin = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgLogo.frame.origin.y + imgLogo.bounds.size.height + 10, self.view.bounds.size.width, 2)];
    imgLineBegin.image = [UIImage imageNamed:@"dotline_gray"];
    [self.view addSubview:imgLineBegin];
    
    UILabel *lblThanks = [[UILabel alloc] initWithFrame:CGRectMake(0, imgLineBegin.frame.origin.y + imgLineBegin.bounds.size.height + 8, 230, 70)];
    lblThanks.center = CGPointMake(self.view.center.x, lblThanks.center.y);
    lblThanks.numberOfLines = 3;
    lblThanks.text = NSLocalizedString(@"shopping_welcome_tips", @"");
    lblThanks.textColor = [UIColor darkGrayColor];
    lblThanks.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblThanks];
    
    UILabel *lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(0, lblThanks.frame.origin.y + lblThanks.bounds.size.height + 2, 300, 22)];
    lblPhone.backgroundColor = [UIColor clearColor];
    lblPhone.textColor = [UIColor darkGrayColor];
    lblPhone.textAlignment = NSTextAlignmentCenter;
    lblPhone.center = CGPointMake(self.view.center.x, lblPhone.center.y);
    lblPhone.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"office_number", @""), NSLocalizedString(@"office_phonenumber", @"")];
    [self.view addSubview:lblPhone];
    
    UILabel *lblWechat = [[UILabel alloc] initWithFrame:CGRectMake(0, lblPhone.frame.origin.y + lblPhone.bounds.size.height + 5, 300, 22)];
    lblWechat.backgroundColor = [UIColor clearColor];
    lblWechat.textAlignment = NSTextAlignmentCenter;
    lblWechat.textColor = [UIColor darkGrayColor];
    lblWechat.center = CGPointMake(self.view.center.x, lblWechat.center.y);
    lblWechat.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"we_chat_number", @"")];
    [self.view addSubview:lblWechat];
    
    UIImageView *imgLineEnd = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblWechat.frame.origin.y + lblWechat.frame.size.height + 10, self.view.bounds.size.width, 2)];
    imgLineEnd.image = [UIImage imageNamed:@"dotline_gray"];
    [self.view addSubview:imgLineEnd];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, imgLineEnd.frame.origin.y + imgLineEnd.bounds.size.height + 8, 280, 90)];
    lblTips.center = CGPointMake(self.view.center.x, lblTips.center.y);
    lblTips.textColor = [UIColor lightGrayColor];
    lblTips.numberOfLines = 5;
    lblTips.font = [UIFont systemFontOfSize:14.f];
    lblTips.text = NSLocalizedString(@"shopping_completed_tips", @"");
    [self.view addSubview:lblTips];
    
    UIButton *btnContinueShopping = [BlueButton blueButtonWithPoint:CGPointMake(0, lblTips.frame.origin.y + lblTips.bounds.size.height + 12) resize:CGSizeMake(260, 30)];
    btnContinueShopping.center = CGPointMake(self.view.center.x, btnContinueShopping.center.y);
    [btnContinueShopping setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnContinueShopping setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnContinueShopping addTarget:self action:@selector(btnContinueShoppingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnContinueShopping setTitle:NSLocalizedString(@"continue_shopping", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnContinueShopping];
}

- (void)btnContinueShoppingPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
