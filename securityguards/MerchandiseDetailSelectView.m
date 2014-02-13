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

@implementation MerchandiseDetailSelectView {
    /* ... for UI ... */
    
    UILabel *lblMerchandiseName;
    UILabel *lblTotalPrice;

    UIWebView *merchandiseIntroduce;
    
    RadioRectButtonGroup *typeGroup;
    RadioRectButtonGroup *colorGroup;
    
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
    
    lblMerchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
    lblMerchandiseName.backgroundColor = [UIColor clearColor];
    lblMerchandiseName.font = [UIFont systemFontOfSize:20.f];
    lblMerchandiseName.text = @"365家庭卫士主机";
    [self addSubview:lblMerchandiseName];
    
    lblTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 80, 30)];
    lblTotalPrice.backgroundColor = [UIColor clearColor];
    lblTotalPrice.textColor = [UIColor orangeColor];
    lblTotalPrice.textAlignment = NSTextAlignmentRight;
    lblTotalPrice.font = [UIFont boldSystemFontOfSize:20.f];
    lblTotalPrice.text = @"￥1999";
    [self addSubview:lblTotalPrice];

    /*  layout from bottom to top  */
    
    UIButton *btnSubmit = [BlueButton blueButtonWithPoint:CGPointMake(0, self.bounds.size.height - 42) resize:CGSizeMake(280, 32)];
    btnSubmit.center = CGPointMake(self.center.x, btnSubmit.center.y);
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted]
    ;
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
//    [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    [typeGroup setSourceItems:[NSMutableArray arrayWithObjects:[[SourceItem alloc] initWithIdentifier:nil displayName:@"标准版"], [[SourceItem alloc] initWithIdentifier:nil displayName:@"高配版"], [[SourceItem alloc] initWithIdentifier:nil displayName:@"低配版"], nil]];
    [self addSubview:typeGroup];
    
    colorGroup = [[RadioRectButtonGroup alloc] initWithFrame:CGRectMake(10 + 40 + 10, lblColor.frame.origin.y, 250, 30)];
    colorGroup.delegate = self;
    colorGroup.identifier = @"colorGroup";
    [colorGroup setSourceItems:[NSMutableArray arrayWithObjects:[[SourceItem alloc] initWithIdentifier:nil displayName:@"红色"], [[SourceItem alloc] initWithIdentifier:nil displayName:@"白色"], nil]];
    [self addSubview:colorGroup];
    
    merchandiseIntroduce = [[UIWebView alloc] initWithFrame:CGRectMake(0, lblMerchandiseName.frame.origin.y + lblMerchandiseName.bounds.size.height, self.bounds.size.width, typeGroup.frame.origin.y - lblMerchandiseName.bounds.size.height - 5 - 5)];
    merchandiseIntroduce.backgroundColor = [UIColor whiteColor];
    [self addSubview:merchandiseIntroduce];
    
    [colorGroup setSelectedSourceItemViaDisplayName:@"红色"];
    [typeGroup setSelectedSourceItemViaDisplayName:@"高配版"];
    
    NumberPicker *numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(10 + 40 + 10, lblNumber.frame.origin.y)];
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
    opacityAnimation.removedOnCompletion = YES;
    [maskView.layer addAnimation:opacityAnimation forKey:nil];
    
    // create pop view's position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
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
    NSLog(@"%@", sourceItem.displayName);
}

#pragma mark -
#pragma mark Number Picker Delegate

- (void)numberPickerDelegate:(NumberPicker *)numberPicker valueDidChangedTo:(int)number {
    NSLog(@"%d", number);
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    
    if(_merchandise_ == nil) {
        
    } else {
        
    }
}

@end
