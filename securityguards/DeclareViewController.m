//
//  DeclareViewController.m
//  securityguards
//
//  Created by hadoop user account on 15/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DeclareViewController.h"

@interface DeclareViewController ()

@end

@implementation DeclareViewController

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
    UITextView *txtDeclare = [[UITextView alloc] initWithFrame:CGRectMake(0, self.topbarView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    txtDeclare.text = NSLocalizedString(@"declare",@"");
    [self.view addSubview:txtDeclare];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
