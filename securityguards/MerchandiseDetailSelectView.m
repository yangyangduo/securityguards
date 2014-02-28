//
//  MerchandiseDetailSelectView.m
//  securityguards
//
//  Created by Zhao yang on 2/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseDetailSelectView.h"
#import "BlueButton.h"
#import "UIColor+MoreColor.h"
#import "ShoppingCart.h"

@implementation MerchandiseDetailSelectView {
    
    ShoppingEntry *shoppingEntry;
    
    /* ... for UI ... */
    
    UILabel *lblMerchandiseName;
    UILabel *lblTotalPrice;

    UIWebView *merchandiseIntroduce;
    
    RadioRectButtonGroup *typeGroup;
    RadioRectButtonGroup *colorGroup;
    
    NumberPicker *numberPicker;
    
    /* ... for animations ... */
    
    BOOL isOpened;
    
    CALayer *backgroundLayer;
    UIView *maskView;
    
    CALayer *_layer_;
    
    UITapGestureRecognizer *_tap_gesture_;
}

@synthesize merchandise = _merchandise_;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isOpened = NO;
    }
    return self;
}

+ (instancetype)merchandiseDetailSelectViewWithMerchandise:(Merchandise *)merchandise {
    static MerchandiseDetailSelectView *selectView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selectView = [[MerchandiseDetailSelectView alloc] initWithMerchandise:nil];
    });
    selectView.merchandise = merchandise;
    return selectView;
}

- (instancetype)initWithMerchandise:(Merchandise *)merchandise {
    if((self = [self initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, MerchandiseDetailSelectViewHeight)])) {
        [self initUI];
        self.merchandise = merchandise;
    }
    return self;
}

- (void)initUI {
    /* ... for UI ... */
    
    self.backgroundColor = [UIColor appGray];
    self.alpha = 0.95f;
    
    lblMerchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 200, 30)];
    lblMerchandiseName.backgroundColor = [UIColor clearColor];
    lblMerchandiseName.font = [UIFont systemFontOfSize:18.f];
    [self addSubview:lblMerchandiseName];
    
    lblTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(205, 3, 80, 30)];
    lblTotalPrice.backgroundColor = [UIColor clearColor];
    lblTotalPrice.textColor = [UIColor orangeColor];
    lblTotalPrice.textAlignment = NSTextAlignmentRight;
    lblTotalPrice.font = [UIFont boldSystemFontOfSize:18.f];
    [self addSubview:lblTotalPrice];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 28, 4, 25, 25)];
    [btnClose addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setImage:[UIImage imageNamed:@"icon_close_orange"] forState:UIControlStateNormal];
    [self addSubview:btnClose];

    /*  layout from bottom to top  */
    
    UIButton *btnSubmit = [BlueButton blueButtonWithPoint:CGPointMake(0, self.bounds.size.height - 42) resize:CGSizeMake(280, 32)];
    btnSubmit.center = CGPointMake(self.center.x, btnSubmit.center.y);
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted]
    ;
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:NSLocalizedString(@"confirm_modify", @"") forState:UIControlStateNormal];
    [self addSubview:btnSubmit];
    
    UILabel *lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, btnSubmit.frame.origin.y - 50, 40, 30)];
    UILabel *lblColor = [[UILabel alloc] initWithFrame:CGRectMake(10, lblNumber.frame.origin.y - 45, 40, 30)];
    UILabel *lblType = [[UILabel alloc] initWithFrame:CGRectMake(10, lblColor.frame.origin.y - 45, 40, 30)];
    
    lblNumber.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"shopping_number", @"")];
    lblColor.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"shopping_color", @"")];
    lblType.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"shopping_type", @"")];
    
    lblNumber.font = [UIFont systemFontOfSize:13.f];
    lblColor.font = [UIFont systemFontOfSize:13.f];
    lblType.font = [UIFont systemFontOfSize:13.f];
    
    lblNumber.textColor = [UIColor darkGrayColor];
    lblColor.textColor = [UIColor darkGrayColor];
    lblType.textColor = [UIColor darkGrayColor];
    
    lblType.backgroundColor = [UIColor clearColor];
    lblColor.backgroundColor = [UIColor clearColor];
    lblNumber.backgroundColor = [UIColor clearColor];
    
    [self addSubview:lblType];
    [self addSubview:lblColor];
    [self addSubview:lblNumber];
    
    typeGroup = [[RadioRectButtonGroup alloc] initWithFrame:CGRectMake(10 + 40 + 10, lblType.frame.origin.y, 250, 30)];
    typeGroup.delegate = self;
    typeGroup.identifier = @"typeGroup";
    [self addSubview:typeGroup];
    
    colorGroup = [[RadioRectButtonGroup alloc] initWithFrame:CGRectMake(10 + 40 + 10, lblColor.frame.origin.y, 250, 30)];
    colorGroup.delegate = self;
    colorGroup.identifier = @"colorGroup";
    [self addSubview:colorGroup];
    
    merchandiseIntroduce = [[UIWebView alloc] initWithFrame:CGRectMake(0, lblMerchandiseName.frame.origin.y + lblMerchandiseName.bounds.size.height, self.bounds.size.width, typeGroup.frame.origin.y - lblMerchandiseName.bounds.size.height - 5 - 5)];
    merchandiseIntroduce.backgroundColor = [UIColor whiteColor];
    [self addSubview:merchandiseIntroduce];
    
    numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(10 + 40 + 10, lblNumber.frame.origin.y)];
    numberPicker.minValue = 0;
    numberPicker.maxValue = 10;
    numberPicker.delegate = self;
    [self addSubview:numberPicker];
    
    /* ... for animations ... */
    
    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.7f;
    _tap_gesture_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [maskView addGestureRecognizer:_tap_gesture_];
    
    backgroundLayer = [CALayer layer];
    backgroundLayer.frame = [UIScreen mainScreen].bounds;
    backgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
}

- (void)showInView:(UIView *)view {
    if(isOpened) return;
    
    if(view == nil || view.superview == nil) return;
    
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _layer_ = view.layer;
    
    // background layer
    [_layer_.superlayer insertSublayer:backgroundLayer below:_layer_];
    
    CATransform3D fromScaleTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CATransform3D toScaleTransform = CATransform3DMakeScale(0.85, 0.85, 1.0);
    
    float fromOpacity = 0.0f;
    float toOpacity = 0.6f;
    
    CGPoint fromPosition = self.layer.position;
    CGPoint toPosition = CGPointMake(fromPosition.x, self.layer.position.y - MerchandiseDetailSelectViewHeight);
    
    [self doAnimationsWithCompetionBlock:^{ isOpened = YES; } fromScaleTransform:fromScaleTransform toScaleTransform:toScaleTransform fromOpacity:fromOpacity toOpacity:toOpacity fromPosition:fromPosition toPosition:toPosition forLayer:_layer_];
}

- (void)dismissView {
    if(!isOpened) return;
    
    CATransform3D fromScaleTransform = CATransform3DMakeScale(0.85, 0.85, 1.0);
    CATransform3D toScaleTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    
    float fromOpacity = 0.6f;
    float toOpacity = 0.0f;
    
    CGPoint fromPosition = self.layer.position;
    CGPoint toPosition = CGPointMake(fromPosition.x, self.layer.position.y + MerchandiseDetailSelectViewHeight);
    
    // clean up after do animations
    [self doAnimationsWithCompetionBlock:^{
        if(maskView.superview != nil) {
            [maskView removeFromSuperview];
        }
        
        if(backgroundLayer.superlayer != nil) {
            [backgroundLayer removeFromSuperlayer];
        }
        
        if(self.superview != nil) {
            [self removeFromSuperview];
        }
        _layer_ = nil;
        isOpened = NO;
    }
    fromScaleTransform:fromScaleTransform toScaleTransform:toScaleTransform
    fromOpacity:fromOpacity toOpacity:toOpacity
    fromPosition:fromPosition toPosition:toPosition forLayer:_layer_];
}

- (void)doAnimationsWithCompetionBlock:(void (^)(void))competionBlock
    fromScaleTransform:(CATransform3D)fromScaleTransform
    toScaleTransform:(CATransform3D)toScaleTransform
    fromOpacity:(float)fromOpacity toOpacity:(float)toOpacity
    fromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition
    forLayer:(CALayer *)layer {
        
    [CATransaction setCompletionBlock:^{
        if(competionBlock != nil) {
            competionBlock();
        }
    }];
    
    [CATransaction begin];
    
    // create container view's scale animation
    CABasicAnimation *scaleViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleViewAnimation.fromValue = [NSValue valueWithCATransform3D:fromScaleTransform];
    scaleViewAnimation.toValue = [NSValue valueWithCATransform3D:toScaleTransform];
    scaleViewAnimation.duration = 0.4f;
    scaleViewAnimation.removedOnCompletion = YES;
    [layer addAnimation:scaleViewAnimation forKey:nil];
    
    // create mask view's opacity animation
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:fromOpacity];
    opacityAnimation.toValue = [NSNumber numberWithFloat:toOpacity];
    opacityAnimation.duration = 0.4f;
    opacityAnimation.removedOnCompletion = YES;
    [maskView.layer addAnimation:opacityAnimation forKey:nil];
    
    // create pop view's position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.4f;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
    positionAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:positionAnimation forKey:nil];
    
    [CATransaction commit];
    
    // after animation
    layer.transform = toScaleTransform;
    maskView.layer.opacity = toOpacity;
    self.layer.position = toPosition;
}

#pragma mark -
#pragma mark Radio Rect Button Group Delegate

- (void)radioRectButtonGroup:(RadioRectButtonGroup *)radioRectButtonGroup selectedSourceItem:(SourceItem *)sourceItem {
    if(shoppingEntry == nil || shoppingEntry.merchandise == nil) return;
    if([@"typeGroup" isEqualToString:radioRectButtonGroup.identifier]) {
        MerchandiseModel *model = [shoppingEntry.merchandise merchandiseModelForName:sourceItem.displayName];
        if(model != nil) {
            shoppingEntry.model = model;
            [self setPrice:shoppingEntry.totalPrice];
        }
    } else if([@"colorGroup" isEqualToString:radioRectButtonGroup.identifier]) {
        MerchandiseColor *color = [shoppingEntry.merchandise merchandiseColorForName:sourceItem.displayName];
        if(color != nil) {
            shoppingEntry.color = color;
        }
    }
}

#pragma mark -
#pragma mark Number Picker Delegate

- (void)numberPickerDelegate:(NumberPicker *)numberPicker valueDidChangedTo:(int)number {
    if(shoppingEntry == nil) return;
    shoppingEntry.number = number;
    [self setPrice:shoppingEntry.totalPrice];
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    if(_merchandise_ == nil) {
        shoppingEntry = nil;
        lblMerchandiseName.text = [XXStringUtils emptyString];
        lblTotalPrice.text = [XXStringUtils emptyString];
        [self setPrice:0.f];
        numberPicker.number = 1;
        [merchandiseIntroduce loadHTMLString:NSLocalizedString(@"no_content_html", @"") baseURL:nil];
        [typeGroup setSourceItems:nil];
        [colorGroup setSourceItems:nil];
    } else {
        lblMerchandiseName.text = merchandise.name;
        if([XXStringUtils isBlank:merchandise.htmlIntroduce]) {
            [merchandiseIntroduce loadHTMLString:NSLocalizedString(@"no_content_html", @"") baseURL:nil];
        } else {
            [merchandiseIntroduce loadHTMLString:merchandise.htmlIntroduce baseURL:nil];
        }
        NSMutableArray *modelSourcesItems = [NSMutableArray array];
        for(int i=0; i<merchandise.merchandiseModels.count; i++) {
            MerchandiseModel *model = [merchandise.merchandiseModels objectAtIndex:i];
            [modelSourcesItems addObject:[[SourceItem alloc] initWithIdentifier:nil displayName:model.name]];
        }
        [typeGroup setSourceItems:modelSourcesItems];
        
        NSMutableArray *colorSourcesItems = [NSMutableArray array];
        for(int i=0; i<merchandise.merchandiseColors.count; i++) {
            MerchandiseColor *color = [merchandise.merchandiseColors objectAtIndex:i];
            [colorSourcesItems addObject:[[SourceItem alloc] initWithIdentifier:nil displayName:color.name]];
        }
        [colorGroup setSourceItems:colorSourcesItems];
        
        ShoppingEntry *_r_entry = [[ShoppingCart shoppingCart] shoppingEntryForId:merchandise.identifier];
        if(_r_entry != nil) {
            shoppingEntry = [_r_entry copy];
            if(shoppingEntry.model != nil) {
                [typeGroup setSelectedSourceItemViaDisplayName:shoppingEntry.model.name];
            }
            if(shoppingEntry.color != nil) {
                [colorGroup setSelectedSourceItemViaDisplayName:shoppingEntry.color.name];
            }
        } else {
            shoppingEntry = [[ShoppingEntry alloc] initWithMerchandise:merchandise];
        }
        numberPicker.number = shoppingEntry.number;
        [self setPrice:shoppingEntry.totalPrice];
    }
}

- (void)setPrice:(float)price {
    lblTotalPrice.text = [NSString stringWithFormat:@"￥%d", (int)price];
}

#pragma mark -
#pragma mark Submit

- (void)btnSubmitPressed:(id)sender {
    [[ShoppingCart shoppingCart] addShoppingEntry:shoppingEntry];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(merchandiseDetailSelectView:willDismissedWithState:)]) {
        [self.delegate merchandiseDetailSelectView:self willDismissedWithState:MerchandiseDetailSelectViewDismissedByConfirmed];
    }
    [self dismissView];
}

@end
