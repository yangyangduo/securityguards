//
//  DeviceCommandUpdateAccount.h
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface DeviceCommandUpdateAccount : DeviceCommand

@property (strong, nonatomic) NSString *oldPwd;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *pwdToUpdate;
@property (assign, nonatomic) int smsLimit;

@end
