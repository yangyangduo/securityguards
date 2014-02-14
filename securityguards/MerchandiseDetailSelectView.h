//
//  MerchandiseDetailSelectView.h
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchandise.h"
#import "RadioRectButtonGroup.h"
#import "NumberPicker.h"

#define MerchandiseDetailSelectViewHeight 400

typedef enum {
    MerchandiseDetailSelectViewDismissedByCancelled,
    MerchandiseDetailSelectViewDismissedByConfirmed,
} MerchandiseDetailSelectViewDismissedBy ;

@protocol MerchandiseDetailSelectViewDelegate;

@interface MerchandiseDetailSelectView : UIView<RadioRectButtonGroupDelegate, NumberPickerDelegate>

@property (nonatomic, weak) id<MerchandiseDetailSelectViewDelegate> delegate;
@property (nonatomic, strong) Merchandise *merchandise;

- (instancetype)initWithMerchandise:(Merchandise *)merchandise;

- (void)showInView:(UIView *)view;
- (void)dismissView;

@end

@protocol MerchandiseDetailSelectViewDelegate <NSObject>

@required

- (void)merchandiseDetailSelectView:(MerchandiseDetailSelectView *)merchandiseDetailSelectView willDismissedWithState:(MerchandiseDetailSelectViewDismissedBy)dismissedBy;

@end