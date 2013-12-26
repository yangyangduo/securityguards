//
//  SMNotification.h
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "NotificationData.h"

@interface SMNotification : Entity

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic, readonly) NSString *typeName;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *mac;
@property (strong, nonatomic) NSDate *createTime;
@property (assign, nonatomic) BOOL hasRead;
@property (assign, nonatomic) BOOL hasProcess;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NotificationData *data;

@property (assign, nonatomic, readonly) BOOL isInfo;
@property (assign, nonatomic, readonly) BOOL isWarning;
@property (assign, nonatomic, readonly) BOOL isValidation;
@property (assign, nonatomic, readonly) BOOL isMessage;
@property (assign, nonatomic, readonly) BOOL isInfoOrMessage;

@end
