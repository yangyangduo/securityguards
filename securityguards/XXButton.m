//
//  XXButton.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXButton.h"
#import "UIImage+ImageHandler.h"

@implementation XXButton {
}

@synthesize identifier;
@synthesize userObject;
@synthesize parameters = _parameters_;
@synthesize longPressDelegate = _longPressDelegate_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (XXButton *) blueButtonWithPoint:(CGPoint)aPoint resize:(CGSize)aSize{
    XXButton *button = [[XXButton alloc] initWithFrame:CGRectMake(aPoint.x, aPoint.y, aSize.width, aSize.height)];
    UIImage *imgNormal = [UIImage reSizeImage:[UIImage imageNamed:@"btn_blue.png"] toSize:aSize];
    UIImage *imgDisable = [UIImage reSizeImage:[UIImage imageNamed:@"btn_gray.png"] toSize:aSize];
    UIImage *imgHighligted = [UIImage reSizeImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] toSize:aSize];
    [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imgDisable forState:UIControlStateDisabled];
    [button setBackgroundImage:imgHighligted forState:UIControlStateHighlighted];
    return button;
}

#pragma mark -
#pragma mark Extension for parameters
    
- (void)setParameter:(id)object forKey:(NSString *)key {
    [self.parameters setObject:object forKey:key];
}
    
- (id)parameterForKey:(NSString *)key {
    return [self.parameters objectForKey:key];
}

#pragma mark -
#pragma mark Extenstions for long press

- (void)setLongPressDelegate:(id<LongPressDelegate>)longPressDelegate {
    for(UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gesture removeTarget:self action:@selector(longPressed:)];
        }
    }
    _longPressDelegate_ = longPressDelegate;
    if(_longPressDelegate_ != nil) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:longPressGesture];
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)gesture {
    if(self.longPressDelegate != nil && gesture.state == UIGestureRecognizerStateBegan) {
        [self.longPressDelegate smButtonLongPressed:self];
    }
}

#pragma mark -
#pragma mark Properties

- (NSMutableDictionary *)parameters {
    if(_parameters_ == nil) {
        _parameters_ = [NSMutableDictionary dictionary];
    }
    return _parameters_;
}

@end
