//
//  MerchandiseBar.h
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchandise.h"

@class PriceRange;

typedef enum {
    MerchandiseBarStateNormal,
    MerchandiseBarStateHighlighted,
} MerchandiseBarState;

@interface MerchandiseBar : UIView

@property (nonatomic, strong) PriceRange *price;
@property (nonatomic, strong) NSString *merchandiseDescriptions;

- (instancetype)initWithPoint:(CGPoint)point;

- (void)setMerchandiseBarState:(MerchandiseBarState)state merchandisePrice:(PriceRange *)merchandisePrice merchandiseDescriptions:(NSString *)merchandiseDescriptions;

@end


@interface PriceRange : NSObject

@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, assign, readonly) BOOL isSingleValue;

- (instancetype)initWithSingleValue:(float)singleValue;
- (instancetype)initWithMaxValue:(float)maxValue minValue:(float)minValue;

- (void)setValue:(Merchandise *)merchandise;
- (void)setSingleValue:(float)singleValue;
- (NSString *)stringForPrice;

@end
