//
//  NumberPicker.h
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberPickerDelegate;

@interface NumberPicker : UIView

+ (instancetype)numberPickerWithPoint:(CGPoint)point;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) int number;
@property (nonatomic, weak) id<NumberPickerDelegate> delegate;

@end

@protocol NumberPickerDelegate <NSObject>

- (void)numberPickerDelegate:(NumberPicker *)numberPicker valueDidChangedTo:(int)number;

@end
