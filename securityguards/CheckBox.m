//
//  CheckBox.m
//  securityguards
//
//  Created by Zhao yang on 2/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox {
    UIButton *btnCheckBox;
    UILabel *lblDescriptions;
}

@synthesize selected = _selected_;
@synthesize title = _title_;

+ (instancetype)checkBoxWithPoint:(CGPoint)point {
    CheckBox *box = [[CheckBox alloc] initWithFrame:CGRectMake(point.x, point.y, 194, 44)];
    return box;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    btnCheckBox = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnCheckBox addTarget:self action:@selector(btnCheckBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    lblDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(btnCheckBox.frame.origin.x + 44, 6, 150, 30)];
    lblDescriptions.textColor = [UIColor lightGrayColor];
    lblDescriptions.backgroundColor = [UIColor clearColor];
    lblDescriptions.textAlignment = NSTextAlignmentCenter;
    lblDescriptions.font = [UIFont systemFontOfSize:14.f];
    lblDescriptions.text = NSLocalizedString(@"contact_tips", @"");
    
    [self addSubview:lblDescriptions];
    [self addSubview:btnCheckBox];
    
    self.selected = NO;
}

- (void)btnCheckBoxPressed:(id)sender {
    self.selected = !_selected_;
}

- (void)setTitle:(NSString *)title {
    _title_ = title;
}

- (void)setSelected:(BOOL)selected {
    _selected_ = selected;
    if(_selected_) {
        [btnCheckBox setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateNormal];
        [btnCheckBox setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateHighlighted];
    } else {
        [btnCheckBox setBackgroundImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
        [btnCheckBox setBackgroundImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateHighlighted];
    }
}

// checkbox_selected@2x
// checkbox_unselected@2x

@end
