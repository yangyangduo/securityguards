//
//  Contact.h
//  securityguards
//
//  Created by Zhao yang on 2/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Entity.h"

@interface Contact : Entity

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *recommended;
@property (nonatomic, strong) NSString *remark;

@end
