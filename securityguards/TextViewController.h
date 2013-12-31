//
//  TextViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

@protocol TextViewDelegate <NSObject>


@end

@interface TextViewController : NavigationViewController

@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSString *txtDescription;
@property (nonatomic, weak) id<TextViewDelegate> delegate;

@end
