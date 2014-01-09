//
//  NewsDetailViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController {
    UIWebView *newsWebView;
}

@synthesize news = _news_;

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

- (id)initWithNews:(News *)news {
    self = [super init];
    if(self) {
        _news_ = news;
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height)];
    newsWebView.backgroundColor = [UIColor redColor];
    [self.view addSubview:newsWebView];
}

- (void)setUp {
    [super setUp];
}

- (void)setNews:(News *)news {
    _news_ = news;
}

@end
