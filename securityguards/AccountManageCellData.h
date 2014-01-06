//
//  AccountManageCellData.h
//  SmartHome
//
//  Created by hadoop user account on 18/11/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface AccountManageCellData : NSObject
@property (strong,nonatomic) User *user;
@property (assign,nonatomic) BOOL isPanel;
@end
