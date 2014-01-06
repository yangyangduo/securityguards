//
//  BaseViewController.m
//  funding
//
//  Created by Zhao yang on 12/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BaseViewController.h"

#define EMPTY_CONTENT_VIEW_TAG 384

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
    [self initDefaults];
    [self initUI];
    [self setUp];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
}

- (void)initUI {
    self.topbarView = [TopbarView topbar];
    self.topbarView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.topbarView];
    self.view.backgroundColor = [UIColor appGray];
    if(![XXStringUtils isBlank:self.title]) {
        self.topbarView.title = self.title;
    }
}

- (void)setUp {
}

#pragma mark -
#pragma mark About first responder

- (void)registerTapGestureToResignKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(triggerTapGestureEventForResignKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture {
    [self resignFirstResponderFor:self.view];
}

- (void)resignFirstResponderFor:(UIView *)view {
    for (UIView *v in view.subviews) {
        if([v isFirstResponder]) {
            [v resignFirstResponder];
            return;
        }
    }
}

#pragma mark -
#pragma mark Empty Content View

- (void)showEmptyContentViewWithMessage:(NSString *)message {
    UIView *emptyContentView = [self.view viewWithTag:EMPTY_CONTENT_VIEW_TAG];
    if(emptyContentView == nil) {
        emptyContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbarView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topbarView.bounds.size.height)];
        emptyContentView.backgroundColor = [UIColor appGray];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:16.f];
        lbl.tag = 777;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 2 - self.topbarView.bounds.size.height);
        [emptyContentView addSubview:lbl];
    }
    UILabel *label = (UILabel *)[emptyContentView viewWithTag:777];
    if([XXStringUtils isBlank:message]) {
        label.text = NSLocalizedString(@"no_content", @"");
    } else {
        label.text = message;
    }
    [self.view addSubview:emptyContentView];
}

- (void)removeEmptyContentView {
    UIView *emptyContentView = [self.view viewWithTag:EMPTY_CONTENT_VIEW_TAG];
    if(emptyContentView != nil) [emptyContentView removeFromSuperview];
}

@end
