//
//  XXActionSheet.H
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterAware.h"

@interface XXActionSheet : UIActionSheet<ParameterAware>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSMutableDictionary *parameters;

@end
