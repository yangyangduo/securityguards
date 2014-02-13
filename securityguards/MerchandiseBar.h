//
//  MerchandiseBar.h
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MerchandiseBarStateNormal,
    MerchandiseBarStateHighlighted,
} MerchandiseBarState;

@interface MerchandiseBar : UIView

@property (nonatomic) float price;
@property (nonatomic, strong) NSString *merchandiseDescriptions;

- (instancetype)initWithPoint:(CGPoint)point;

- (void)setMerchandiseBarState:(MerchandiseBarState)state merchandisePrice:(float)merchandisePrice merchandiseDescriptions:(NSString *)merchandiseDescriptions;

@end
