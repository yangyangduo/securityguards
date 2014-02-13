//
//  MerchandiseDetailSelectView.h
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchandise.h"

#define MerchandiseDetailSelectViewHeight 400

@protocol MerchandiseDetailSelectViewDelegate;

@interface MerchandiseDetailSelectView : UIView

@property (nonatomic, weak) id<MerchandiseDetailSelectViewDelegate> delegate;
@property (nonatomic, strong) Merchandise *merchandise;

- (instancetype)initWithMerchandise:(Merchandise *)merchandise;

- (void)showInView:(UIView *)view;
- (void)dismissView;

@end

@protocol MerchandiseDetailSelectViewDelegate <NSObject>

@required

- (void)merchandiseDetailSelectView:(MerchandiseDetailSelectView *)merchandiseDetailSelectView;

@end