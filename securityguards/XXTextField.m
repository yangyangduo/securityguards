//
//  XXTextField.m
//  securityguards
//
//  Created by hadoop user account on 30/12/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXTextField.h"

@implementation XXTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UITextField *)textFieldWithPoint:(CGPoint) point{
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(point.x,point.y, 400/2, 53/2)];
    txtField.background = [UIImage imageNamed:@"bg_textbox"];
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtField.autocorrectionType = UITextAutocapitalizationTypeNone;
    txtField.font = [UIFont systemFontOfSize:14.f];
    txtField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    txtField.leftViewMode = UITextFieldViewModeAlways;
    txtField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    return txtField;
}

@end
