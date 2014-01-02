//
//  UnitRenameViewController.m
//  securityguards
//
//  Created by Zhao yang on 1/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitRenameViewController.h"
#import "UnitManager.h"
#import "DeviceCommandNameEventFilter.h"

@interface UnitRenameViewController ()

@end

@implementation UnitRenameViewController

@synthesize unit = _unit_;

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

- (id)init {
    self = [super init];
    if(self) {
        self.txtDescription = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"enter_new_unit_name", @"")];
        self.title = NSLocalizedString(@"rename_unit", @"");
    }
    return self;
}

- (id)initWithUnit:(Unit *)unit {
    self = [self init];
    if(self) {
        self.unit = unit;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

#pragma mark -
#pragma mark Text View Delegate

- (void)btnSubmitPressed:(id)sender {
    if([XXStringUtils isBlank:self.value]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unit_name_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:NO];
        return;
    }
    
    if([self.unit.name isEqualToString:self.value]) {
        [self popupViewController];
        return;
    }
    
    [[AlertView currentAlertView] setMessage:@"please_wait" forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:YES];
    
    DeviceCommandUpdateUnitName *updateUnitNameCommand = (DeviceCommandUpdateUnitName *)[CommandFactory commandForType:CommandTypeUpdateUnitName];
    updateUnitNameCommand.masterDeviceCode = self.unit.identifier;
    updateUnitNameCommand.name = self.value;
    [[CoreService defaultService] executeDeviceCommand:updateUnitNameCommand];
    
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)setUnit:(Unit *)unit {
    _unit_ = unit;
    self.defaultValue = _unit_ != nil ? _unit_.name : nil;
}

@end
