//
//  TextViewController.h
//  securityguards
//
//  Created by Zhao yang on 12/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationViewController.h"

#define SUBMIT_BUTTON_TAG 1000
#define TEXT_FIELD_TAG    1001

@protocol TextViewDelegate;

@interface TextViewController : NavigationViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSString *txtDescription;
@property (nonatomic, weak) id<TextViewDelegate> delegate;

- (void)btnSubmitPressed:(id)sender;
- (void)close;

@end

@protocol TextViewDelegate <NSObject>

- (void)textView:(TextViewController *)textView newText:(NSString *)newText;

@end