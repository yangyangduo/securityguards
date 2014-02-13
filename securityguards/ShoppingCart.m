//
//  ShoppingCart.m
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCart.h"

@implementation ShoppingCart {
    NSMutableArray *_shopping_entries_;
}

@synthesize totalPrice = _totalPrice_;

+ (instancetype)shoppingCart {
    static ShoppingCart *shoppingCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shoppingCart = [[ShoppingCart alloc] init];
    });
    return shoppingCart;
}

- (id)init {
    self = [super init];
    if(self) {
        _shopping_entries_ = [NSMutableArray array];
    }
    return self;
}

- (float)totalPrice {
    if(_shopping_entries_ == nil || _shopping_entries_.count == 0) {
        return 0;
    }
    
    float total = 0;
    for(int i=0; i<_shopping_entries_.count; i++) {
        ShoppingEntry *entry = [_shopping_entries_ objectAtIndex:i];
        total += entry.totalPrice;
    }
    
    return total;
}

@end

@implementation ShoppingEntry

@synthesize model;
@synthesize color;
@synthesize number;
@synthesize merchandise = _merchandise_;

- (id)initWithMerchandise:(Merchandise *)merchandise {
    self = [super init];
    if(self) {
        self.number = 1;
        self.merchandise = merchandise;
    }
    return self;
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    self.model = nil;
    self.color = nil;
    if(_merchandise_ != nil) {
        if(merchandise.merchandiseColors != nil && merchandise.merchandiseColors.count > 0) {
            self.color  = [merchandise.merchandiseColors objectAtIndex:0];
        }
        if(merchandise.merchandiseModels != nil && merchandise.merchandiseModels.count > 0) {
            self.model = [merchandise.merchandiseModels objectAtIndex:0];
        }
    }
    self.number = 1;
}

- (float)totalPrice {
    if(self.merchandise == nil || self.model == nil) {
        return 0;
    }
    return self.model.price * self.number;
}

@end

