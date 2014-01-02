//
//  NotificationDetailsViewController.m
//  securityguards
//
//  Created by hadoop user account on 31/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationDetailsViewController.h"
#import "MessageCell.h"
#import "XXDateFormatter.h"

@interface NotificationDetailsViewController ()

@end

@implementation NotificationDetailsViewController
@synthesize notification = _notification_;
@synthesize delegate;

- (id)initWithNotification:(SMNotification *)notification {
    self = [super init];
    if (self) {
        _notification_ = notification;
    }
    return self;
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

- (void)initDefaults {
}



@end
