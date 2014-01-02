//
//  UnitRenameViewController.h
//  securityguards
//
//  Created by Zhao yang on 1/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TextViewController.h"

@interface UnitRenameViewController : TextViewController

@property (nonatomic, strong) Unit *unit;

- (id)initWithUnit:(Unit *)unit;

@end
