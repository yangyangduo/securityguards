//
//  MerchandiseBar.m
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseBar.h"
#import "UIColor+MoreColor.h"
#import "XXStringUtils.h"

@implementation MerchandiseBar {
    UILabel *lblPrice;
    UILabel *lblDescriptions;
}

@synthesize price = _price_;
@synthesize merchandiseDescriptions = _merchandiseDescriptions_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor appDarkGray];
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(141, 7, 140, 30)];
        lblDescriptions = [[UILabel alloc] initWithFrame:CGRectMake(215, 18, 95, 20)];
        
        lblPrice.textColor = [UIColor orangeColor];
        lblPrice.font = [UIFont boldSystemFontOfSize:18.f];
        
        lblDescriptions.textColor = [UIColor whiteColor];
        lblDescriptions.font = [UIFont systemFontOfSize:11.f];
        lblDescriptions.textAlignment = NSTextAlignmentCenter;
        
        lblPrice.backgroundColor = [UIColor clearColor];
        lblDescriptions.backgroundColor = [UIColor clearColor];
        
        [self addSubview:lblPrice];
        [self addSubview:lblDescriptions];
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point {
    if((self = [self initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 44)])) {
    }
    return self;
}

- (void)setMerchandiseBarState:(MerchandiseBarState)state merchandisePrice:(PriceRange *)merchandisePrice merchandiseDescriptions:(NSString *)merchandiseDescriptions {
    
    _price_ = merchandisePrice;
    _merchandiseDescriptions_ = merchandiseDescriptions;
    
    lblPrice.text = [NSString stringWithFormat:@"￥%@", [merchandisePrice stringForPrice]];
    lblDescriptions.text = [XXStringUtils isBlank:self.merchandiseDescriptions] ? [XXStringUtils emptyString] :self.merchandiseDescriptions;
    
    if(state == MerchandiseBarStateNormal) {
        self.backgroundColor = [UIColor appDarkGray];
        lblPrice.textColor = [UIColor orangeColor];
        lblDescriptions.hidden = YES;
    } else if(state == MerchandiseBarStateHighlighted) {
        self.backgroundColor = [UIColor orangeColor];
        lblPrice.textColor = [UIColor whiteColor];
        lblDescriptions.hidden = NO;
    }
}

@end


@implementation PriceRange

@synthesize maxValue = _maxValue_;
@synthesize minValue = _minValue_;
@synthesize isSingleValue = _isSingleValue_;

- (instancetype)initWithSingleValue:(float)singleValue {
    self = [super init];
    if(self) {
        _isSingleValue_ = YES;
        self.maxValue = singleValue;
        self.minValue = singleValue;
    }
    return self;
}

- (instancetype)initWithMaxValue:(float)maxValue minValue:(float)minValue {
    self = [super init];
    if(self) {
        self.minValue = minValue;
        self.maxValue = maxValue;
        _isSingleValue_ = self.maxValue > self.minValue;
    }
    return self;
}

- (void)setValue:(Merchandise *)merchandise {
    self.maxValue = 0;
    self.minValue = 0;
    
    if(merchandise != nil && merchandise.merchandiseModels != nil
        && merchandise.merchandiseModels.count > 0) {
        
        if(merchandise.merchandiseModels.count == 1) {
            MerchandiseModel *model = [merchandise.merchandiseModels objectAtIndex:0];
            self.minValue = model.price;
            self.maxValue = model.price;
            _isSingleValue_ = YES;
        }
        
        for(int i=0; i<merchandise.merchandiseModels.count; i++) {
            MerchandiseModel *model = [merchandise.merchandiseModels objectAtIndex:i];
            if(i == 0) {
                self.minValue = model.price;
                self.maxValue = model.price;
                continue;
            }
            if(model.price < self.minValue) {
                self.minValue = model.price;
            }
            
            if(model.price > self.maxValue) {
                self.maxValue = model.price;
            }
        }
        
        _isSingleValue_ = !(self.maxValue > self.minValue);
    } else {
        _isSingleValue_ = YES;
    }
}

- (void)setSingleValue:(float)singleValue {
    _isSingleValue_ = YES;
    self.minValue = singleValue;
    self.maxValue = singleValue;
}

- (NSString *)stringForPrice {
    if(_isSingleValue_) return [NSString stringWithFormat:@"%d", (int)self.minValue];
    return [NSString stringWithFormat:@"%d ~ %d", (int)self.minValue, (int)self.maxValue];
}

@end
