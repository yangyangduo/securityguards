//
//  UnitRenameViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TextViewController.h"
#import "XXEventSubscriber.h"

@interface UnitRenameViewController : TextViewController<XXEventSubscriber>

@property (nonatomic, strong) Unit *unit;

- (id)initWithUnit:(Unit *)unit;

@end
