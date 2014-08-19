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
#import "UnitNameChangedEvent.h"

@interface UnitRenameViewController ()

@end

@implementation UnitRenameViewController

@synthesize unit = _unit_;

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
    [super viewWillAppear:animated];
    
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventName:EventUnitNameChanged]];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[UnitNameChangedEvent class]]) {
        UnitNameChangedEvent *evt = (UnitNameChangedEvent *)event;
        if([XXStringUtils isBlank:evt.unitIdentifier]) {
            if([XXAlertView currentAlertView].alertViewState == AlertViewStateDidAppear || [XXAlertView currentAlertView].alertViewState == AlertViewStateWillAppear) {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unit_name_change_failed", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] delayDismissAlertView];
            }
        } else {
            if([XXAlertView currentAlertView].alertViewState == AlertViewStateDidAppear || [XXAlertView currentAlertView].alertViewState == AlertViewStateWillAppear) {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unit_name_change_success", @"") forType:AlertViewTypeSuccess];
                [[XXAlertView currentAlertView] delayDismissAlertView];
                [self popupViewController];
            }
        }
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"UnitRenameViewControllerSubscriber";
}

#pragma mark -
#pragma mark Text View Delegate

- (void)btnSubmitPressed:(id)sender {
    if([XXStringUtils isBlank:self.value]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"unit_name_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    } else if(self.value.length > 8) {
        [[XXAlertView currentAlertView] setMessage:@"名字太长" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([self.unit.name isEqualToString:self.value]) {
        [self popupViewController];
        return;
    }
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES timeout:10.f timeoutMessage:NSLocalizedString(@"request_timeout", @"")];
    
    DeviceCommandUpdateUnitName *updateUnitNameCommand = (DeviceCommandUpdateUnitName *)[CommandFactory commandForType:CommandTypeUpdateUnitName];
    updateUnitNameCommand.masterDeviceCode = self.unit.identifier;
    updateUnitNameCommand.name = self.value;
    [[CoreService defaultService] executeDeviceCommand:updateUnitNameCommand];
}

- (void)setUnit:(Unit *)unit {
    _unit_ = unit;
    self.defaultValue = _unit_ != nil ? _unit_.name : nil;
}

@end
