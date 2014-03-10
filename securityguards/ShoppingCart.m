//
//  ShoppingCart.m
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCart.h"
#import "GlobalSettings.h"

@implementation ShoppingCart {
    NSMutableArray *_shopping_entries_;
}

@synthesize totalPrice = _totalPrice_;
@synthesize contact;

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

- (NSArray *)shoppingEntries {
    return _shopping_entries_;
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

- (void)clearShoppingCart {
    [_shopping_entries_ removeAllObjects];
}

- (ShoppingEntry *)shoppingEntryForId:(NSString *)merchandiseIdentifier {
    if([XXStringUtils isBlank:merchandiseIdentifier]) return nil;
    for(int i=0; i<_shopping_entries_.count; i++) {
        ShoppingEntry *entry = [_shopping_entries_ objectAtIndex:i];
        if(entry.merchandise != nil && [entry.merchandise.identifier isEqualToString:merchandiseIdentifier]) {
            return entry;
        }
    }
    return nil;
}

- (void)addShoppingEntry:(ShoppingEntry *)shoppingEntry {
    if(shoppingEntry == nil || shoppingEntry.merchandise == nil) return;
    int index = -1;
    
    for(int i=0; i<_shopping_entries_.count; i++) {
        ShoppingEntry *entry = [_shopping_entries_ objectAtIndex:i];
        if(shoppingEntry.merchandise == nil) continue;
        if([entry.merchandise.identifier isEqualToString:shoppingEntry.merchandise.identifier]) {
            index = i;
            break;
        }
    }
    
    if(index == -1) {
        if(shoppingEntry.number == 0) return;
        [_shopping_entries_ addObject:shoppingEntry];
    } else {
        if(shoppingEntry.number == 0) {
            [_shopping_entries_ removeObjectAtIndex:index];
        } else {
            [_shopping_entries_ replaceObjectAtIndex:index withObject:shoppingEntry];
        }
    }
}

- (void)removeShoppingEntryByMerchandiseIdentifier:(NSString *)merchandiseIdentifier {
    ShoppingEntry *found = nil;
    for(int i=0; i<_shopping_entries_.count; i++) {
        ShoppingEntry *entry = [_shopping_entries_ objectAtIndex:i];
        if([entry.merchandise.identifier isEqualToString:merchandiseIdentifier]) {
            found = entry;
            break;
        }
    }
    if(found != nil) {
        [_shopping_entries_ removeObject:found];
    }
}

- (NSDictionary *)toDictionary {
    if(self.contact == nil) return nil;
    if(self.shoppingEntries == nil || self.shoppingEntries.count == 0) return nil;
    
    NSMutableArray *_json_arr_ = [NSMutableArray array];
    for(int i=0; i<self.shoppingEntries.count; i++) {
        ShoppingEntry *et = [self.shoppingEntries objectAtIndex:i];
        if(et == nil) continue;
        [_json_arr_ addObject:[et toDictionary]];
    }
    
    if(_json_arr_.count == 0) return nil;
    
    NSString *accountId = [NSString stringWithFormat:@"%@%@", [GlobalSettings defaultSettings].deviceCode, APP_KEY];
    
    NSDictionary *json =
    @{
       @"ca"  : @{
                    @"ci"  : _json_arr_
               },
       @"cr"  : @{ @"_id" : accountId },
       @"co"  : @{
               @"_id"  : accountId,
               @"name" : [XXStringUtils noNilStringFor:self.contact.name],
               @"tel"  : [XXStringUtils noNilStringFor:self.contact.phoneNumber],
               @"del"  : [XXStringUtils noNilStringFor:self.contact.address]
               },
       @"rem" : [XXStringUtils noNilStringFor:self.contact.remark],
       @"rc"  : @{ @"phoneNumber" : self.contact.recommended == nil ? [XXStringUtils emptyString] : self.contact.recommended }
    };
    
    return json;
}

@end

@implementation ShoppingEntry

@synthesize totalPrice;
@synthesize model;
@synthesize color;
@synthesize number;
@synthesize merchandise = _merchandise_;

- (id)copy {
    ShoppingEntry *entry = [[ShoppingEntry alloc] init];
    entry.merchandise = self.merchandise;
    entry.model = self.model;
    entry.color = self.color;
    entry.number = self.number;
    return entry;
}

- (id)initWithMerchandise:(Merchandise *)merchandise {
    self = [super init];
    if(self) {
        self.number = 1;
        self.merchandise = merchandise;
    }
    return self;
}

- (NSDictionary *)toDictionary {
    if(self.merchandise == nil) return nil;
    return
    @{
      @"pro" : @{@"id"  : self.merchandise.identifier, @"ti" : self.merchandise.name},
      @"pri" : @{@"mod" : self.model.name},
      @"col" : @{@"nam" : self.color.name},
      @"nu"  : [NSNumber numberWithInteger:self.number]
      };
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    self.model = nil;
    self.color = nil;
    if(_merchandise_ != nil) {
        // set first one to default
        
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

- (NSString *)shoppingEntryDetailsAsString {
    return [NSString stringWithFormat:@"%@, %@ X %d", self.model.name, self.color.name, self.number];
}

@end

