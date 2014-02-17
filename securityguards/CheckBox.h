//
//  CheckBox.h
//  securityguards
//
//  Created by Zhao yang on 2/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBox : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSString *title;

+ (instancetype)checkBoxWithPoint:(CGPoint)point;

@end
