//
//  DeviceCommandGetAccountHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetAccountHandler.h"
//#import "ViewsPool.h"

@implementation DeviceCommandGetAccountHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
        DeviceCommandUpdateAccount *deviceCommand = (DeviceCommandUpdateAccount *)command;
//        NavigationView *nav = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"portalView"];
//        if(nav != nil) {
//            DrawerView *drawerView = (DrawerView *)nav.ownerController.leftView;
//            if(drawerView != nil) {
//                [drawerView setScreenName:deviceCommand.screenName];
//            }
//        }
    }
}

@end
