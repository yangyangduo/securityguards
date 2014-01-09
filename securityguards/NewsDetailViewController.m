//
//  NewsDetailViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "RestClient.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController {
    UIWebView *newsWebView;
    RestClient *client;
    UITapGestureRecognizer *tapGesture;
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
    client = [[RestClient alloc] init];
    client.timeoutInterval = 10.f;
}

- (void)initUI {
    [super initUI];
    newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height)];
    newsWebView.delegate = self;
    [self.view addSubview:newsWebView];
}

- (void)setUp {
    [super setUp];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadPage];
}

- (void)loadPage {
    if(self.news == nil || [XXStringUtils isBlank:self.news.contentUrl]) return;
    [self showLoadingViewWithMessage:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [client get:self.news.contentUrl acceptType:@"text/html"
            success:^(RestResponse *resp) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(resp.statusCode == 200) {
                        NSString *htmlString = [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
                        [newsWebView loadHTMLString:htmlString baseURL:nil];
                        [self removeLoadingView];
                    } else {
                        [self loadWasFailed];
                    }
                });
            }
            error:^(RestResponse *resp) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadWasFailed];
                });
            }];
    });
}

- (void)loadWasFailed {
    [self removeLoadingView];
    [self showEmptyContentViewWithMessage:NSLocalizedString(@"retry_loading", @"")];
    if(tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadPage)];
    }
    [self.view addGestureRecognizer:tapGesture];
}

- (void)reloadPage {
    self.news.contentUrl = @"http://www.baidu.com";
    [self.view removeGestureRecognizer:tapGesture];
    [self removeEmptyContentView];
    [self loadPage];
}

#pragma mark -
#pragma mark Web View Delegate


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSDictionary *dic =    request.allHTTPHeaderFields;
    for(NSString *str in    dic.allKeys) {
        NSLog(@"%@   :   %@", str, [dic objectForKey:str]);
        NSLog(@"------>");
    }
    
    return YES;
}

- (void)setNews:(News *)news {
    _news_ = news;
}

@end
