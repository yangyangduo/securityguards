//
//  ContactUsViewController.m
//  securityguards
//
//  Created by hadoop user account on 15/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ContactUsViewController.h"
#import "SystemService.h"
#import "DeclareViewController.h"

#define LABEL_HEIGHT  30

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

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

- (void)initUI{
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"contact_us_drawer_title", @"");
    
    UILabel *lblAppName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.topbarView.frame.size.height + 5, 200, LABEL_HEIGHT)];
    lblAppName.textColor = [UIColor darkGrayColor];
    lblAppName.backgroundColor = [ UIColor clearColor];
    lblAppName.text = NSLocalizedString(@"app_name_label", @"");
    [self.view addSubview:lblAppName];
    
    UILabel *lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+LABEL_HEIGHT + self.topbarView.frame.size.height, 200, LABEL_HEIGHT)];
    lblVersion.textColor = [UIColor darkGrayColor];
    lblVersion.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
    NSString *versionStr = [dic objectForKey:@"CFBundleVersion"];
    lblVersion.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"app_version", @""),versionStr];
    [self.view addSubview:lblVersion];
    
    UILabel *lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + self.topbarView.frame.size.height + LABEL_HEIGHT*2, 85, LABEL_HEIGHT)];
    lblPhoneNumber.text = NSLocalizedString(@"office_number", @"");
    lblPhoneNumber.textColor = [UIColor darkGrayColor];
    lblPhoneNumber.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblPhoneNumber];
    
    UIButton *btnCallOfficeServer = [[UIButton alloc] initWithFrame:CGRectMake(95,5 + self.topbarView.frame.size.height + LABEL_HEIGHT * 2, 200, LABEL_HEIGHT)];
    [btnCallOfficeServer setTitle:NSLocalizedString(@"office_phonenumber", @"") forState:UIControlStateNormal];
    btnCallOfficeServer.backgroundColor = [UIColor clearColor];
    btnCallOfficeServer.titleEdgeInsets = UIEdgeInsetsMake(btnCallOfficeServer.titleEdgeInsets.top, -60, btnCallOfficeServer.titleEdgeInsets.bottom, btnCallOfficeServer.titleEdgeInsets.right);
    [btnCallOfficeServer setTitleColor:[UIColor appLightBlue] forState:UIControlStateHighlighted];
    [btnCallOfficeServer setTitleColor:[UIColor appBlue] forState:UIControlStateNormal];
    [btnCallOfficeServer addTarget:self action:@selector(btnCallOfficeServerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCallOfficeServer];
    
    UILabel *lblWeChatNum = [[UILabel alloc] initWithFrame:CGRectMake(10,5 + self.topbarView.frame.size.height + LABEL_HEIGHT * 3, 200, LABEL_HEIGHT)];
    lblWeChatNum.textColor = [UIColor darkGrayColor];
    lblWeChatNum.text = NSLocalizedString(@"we_chat_number", @"");
    lblWeChatNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblWeChatNum];
    
    UILabel *lblWebSite = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+self.topbarView.frame.size.height + LABEL_HEIGHT * 4, 85, LABEL_HEIGHT)];
    lblWebSite.backgroundColor = [UIColor clearColor];
    lblWebSite.text = NSLocalizedString(@"website", @"");
    lblWebSite.textColor = [UIColor darkGrayColor];
    [self.view addSubview:lblWebSite];
    
    UIButton *btnOpenWebSite = [[UIButton alloc] initWithFrame:CGRectMake(95, 5 + self.topbarView.frame.size.height + LABEL_HEIGHT * 4, 200, LABEL_HEIGHT)];
    btnOpenWebSite.backgroundColor = [UIColor clearColor];
    [btnOpenWebSite setTitle:NSLocalizedString(@"website_url", @"") forState:UIControlStateNormal];
    [btnOpenWebSite setTitleColor:[UIColor appBlue] forState:UIControlStateNormal];
    [btnOpenWebSite setTitleColor:[UIColor appLightBlue] forState:UIControlStateHighlighted];
    btnOpenWebSite.titleEdgeInsets = UIEdgeInsetsMake(btnOpenWebSite.titleEdgeInsets.top,-60, btnOpenWebSite.titleEdgeInsets.bottom, btnOpenWebSite.titleEdgeInsets.right);
    [btnOpenWebSite addTarget:self action:@selector(btnOpenWebSitePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOpenWebSite];
    
    UILabel *lblCopyRight = [[UILabel alloc] initWithFrame:CGRectMake(10,  5 + self.topbarView.frame.size.height + LABEL_HEIGHT * 5, 300, LABEL_HEIGHT)];
    lblCopyRight.backgroundColor = [UIColor clearColor];
    lblCopyRight.textColor = [UIColor darkGrayColor];
    lblCopyRight.text = NSLocalizedString(@"copyright", @"");
    lblCopyRight.font = [UIFont systemFontOfSize:11.f];
    [self.view addSubview:lblCopyRight];
    
    UIView *clickToDeclareView = [[UIView alloc] initWithFrame:CGRectMake(10, 5 + self.topbarView.frame.size.height + LABEL_HEIGHT * 6, 300, 50)];
    clickToDeclareView.backgroundColor = [UIColor appGray];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToDeclare:)];
    [clickToDeclareView addGestureRecognizer:tapGesture];
    [self.view addSubview:clickToDeclareView];
    
    UILabel *lblReadDeclare = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,150, 50)];
    lblReadDeclare.backgroundColor = [UIColor clearColor];
    lblReadDeclare.text = NSLocalizedString(@"read_declare", @"");
    NSLog(@"%@",NSStringFromCGRect(lblReadDeclare.frame));
    lblReadDeclare.textColor = [UIColor darkGrayColor];
    [clickToDeclareView addSubview:lblReadDeclare];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(clickToDeclareView.frame.size.width-16, 15, 8, 41/2)];
    accessoryView.backgroundColor = [UIColor clearColor];
    accessoryView.image = [UIImage imageNamed:@"icon_accessory.png"];
    [clickToDeclareView addSubview:accessoryView];
}

- (void)btnCallOfficeServerPressed:(UIButton *)sender{
    [SystemService dialToMobile:NSLocalizedString(@"office_phonenumber", @"")];
}

- (void)btnOpenWebSitePressed:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.365jws.com"]];
}
- (void)clickToDeclare:(UITapGestureRecognizer *)gesture{
    [self.navigationController pushViewController:[[DeclareViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
