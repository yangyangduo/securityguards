//
//  ShoppingStateView.h
//  securityguards
//
//  Created by Zhao yang on 2/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ShoppingStateSelecting = 1,
    ShoppingStateConfirmOrder = 2,
    ShoppingStateCompleted = 3,
} ShoppingState;

@interface ShoppingStateView : UIView

@property (nonatomic, assign) ShoppingState state;

- (instancetype)initWithPoint:(CGPoint)point shoppingState:(ShoppingState)shoppingState;

@end
