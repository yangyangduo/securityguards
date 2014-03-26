//
//  DeclareViewController.m
//  securityguards
//
//  Created by hadoop user account on 15/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeclareViewController.h"

#define INDICATOR_TAG 2000

@interface DeclareViewController ()

@end

@implementation DeclareViewController{
    UIWebView *declarePage;
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
- (void)initUI{
    [super initUI];
    
    if (declarePage == nil) {
        declarePage = [[UIWebView alloc] initWithFrame:CGRectMake(0,self.topbarView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topbarView.frame.size.height)];
        declarePage.delegate = self;
        declarePage.backgroundColor = [UIColor clearColor];
        [self.view addSubview:declarePage];
    }
    [self loadPage];
    self.topbarView.title = NSLocalizedString(@"declare_title", @"");
//    UITextView *txtDeclare = [[UITextView alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topbarView.frame.size.height)];
//    txtDeclare.text = NSLocalizedString(@"declare",@"");
//    txtDeclare.editable = NO;
//    [self.view addSubview:txtDeclare];
}

- (void)loadPage{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"declare" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:sourcePath];
    if(data) {
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"data str%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [declarePage loadHTMLString:htmlString baseURL:nil];
    }
}
#pragma mark -
#pragma mark webview delegate methods
    
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingViewWithMessage:nil];
}
    
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self removeLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

@end
