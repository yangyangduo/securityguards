//
//  ShoppingCart.h
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Merchandise.h"
#import "Contact.h"

@class ShoppingEntry;

@interface ShoppingCart : NSObject

@property (nonatomic, assign, readonly) float totalPrice;
@property (nonatomic, strong) Contact *contact;

+ (instancetype)shoppingCart;

- (NSArray *)shoppingEntries;
- (ShoppingEntry *)shoppingEntryForId:(NSString *)merchandiseIdentifier;
- (void)clearShoppingCart;
- (void)addShoppingEntry:(ShoppingEntry *)shoppingEntry;
- (void)removeShoppoingEntryByMerchandiseIdentifier:(NSString *)merchandiseIdentifier;

@end


@interface ShoppingEntry : NSObject

@property (nonatomic, assign, readonly) float totalPrice;
@property (nonatomic, strong) Merchandise *merchandise;
@property (nonatomic, strong) MerchandiseModel *model;
@property (nonatomic, strong) MerchandiseColor *color;
@property (nonatomic, assign) unsigned int number;

- (instancetype)initWithMerchandise:(Merchandise *)merchandise;
- (NSString *)shoppingEntryDetailsAsString;

@end
