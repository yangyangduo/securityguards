//
//  BaseViewController.m
//  securityguards
//
//  Created by Zhao yang on 3/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize topbarView;

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

- (void)initUI {
    [super initUI];
    self.topbarView = [XXTopbarView topbar];
    [self.view addSubview:self.topbarView];
    self.view.backgroundColor = [UIColor whiteColor];
    if(![XXStringUtils isBlank:self.title]) {
        self.topbarView.title = self.title;
    }
    self.topbarView.backgroundImage =  [UIImage imageNamed:@"bg_topbar"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
