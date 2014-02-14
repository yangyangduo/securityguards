//
//  NumberPicker.m
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NumberPicker.h"
#import "UIColor+MoreColor.h"

#define WIDTH 45
#define HEIGHT 30

@implementation NumberPicker {
    UIButton *btnAddition;
    UIButton *btnReduction;
    UILabel *lblNumber;
}

@synthesize number = _number_;
@synthesize identifier;
@synthesize maxValue;
@synthesize minValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // min && max value
        self.minValue = 1;
        self.maxValue = 99;
        
        // default value
        self.number = 1;
        [self initUI];
    }
    return self;
}

+ (instancetype)numberPickerWithPoint:(CGPoint)point {
    return [[NumberPicker alloc] initWithFrame:CGRectMake(point.x, point.y, WIDTH * 3 - 2, HEIGHT)];
}

+ (instancetype)numberPickerWithPoint:(CGPoint)point defaultValue:(int)defaultValue {
    NumberPicker *picker = [[self class] numberPickerWithPoint:point];
    picker.number = defaultValue;
    return picker;
}

- (void)initUI {
    btnReduction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    btnAddition = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH * 2 - 2, 0, WIDTH, HEIGHT)];
    
    btnAddition.tag = 1;
    btnReduction.tag = 2;
    
    [btnAddition addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnReduction addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAddition addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnAddition addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [btnReduction addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnReduction addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    btnReduction.layer.borderColor = [UIColor grayColor].CGColor;
    btnAddition.layer.borderColor = [UIColor grayColor].CGColor;
    
    btnAddition.layer.borderWidth = 1;
    btnReduction.layer.borderWidth = 1;
    
    btnAddition.backgroundColor = [UIColor clearColor];
    btnReduction.backgroundColor = [UIColor clearColor];
    
    [btnReduction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnAddition setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    btnAddition.titleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    btnReduction.titleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    
    [btnAddition setTitle:@"+" forState:UIControlStateNormal];
    [btnReduction setTitle:@"-" forState:UIControlStateNormal];
    
    lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 1, 0, WIDTH, HEIGHT)];
    lblNumber.layer.borderColor = [UIColor grayColor].CGColor;
    lblNumber.layer.borderWidth = 1;
    lblNumber.textColor = [UIColor orangeColor];
    lblNumber.textAlignment = NSTextAlignmentCenter;
    lblNumber.backgroundColor = [UIColor clearColor];
    lblNumber.text = [NSString stringWithFormat:@"%d", self.number];
    
    [self addSubview:lblNumber];
    [self addSubview:btnAddition];
    [self addSubview:btnReduction];
}

- (void)btnPressed:(UIButton *)sender {
    if(sender.tag == 1) {
        if(self.number + 1 <= self.maxValue) {
            self.number = self.number + 1;
        }
    } else if(sender.tag == 2) {
        if(self.number - 1 >= self.minValue) {
            self.number = self.number - 1;
        }
    }
    sender.backgroundColor = [UIColor clearColor];
}

- (void)btnTouchDown:(UIButton *)sender {
    sender.backgroundColor = [UIColor appDarkBlue];
}

- (void)btnTouchUpOutside:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

- (void)setNumber:(int)number {
    if(number < self.minValue || number > self.maxValue) return;
    if(number == _number_) return;
    _number_ = number;
    lblNumber.text = [NSString stringWithFormat:@"%d", number];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(numberPickerDelegate:valueDidChangedTo:)]) {
        [self.delegate numberPickerDelegate:self valueDidChangedTo:_number_];
    }
}

@end
