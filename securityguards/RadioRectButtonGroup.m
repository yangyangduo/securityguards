//
//  RadioRectButtonGroup.m
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "RadioRectButtonGroup.h"
#import "XXStringUtils.h"

@implementation RadioRectButtonGroup {
    int _selected_index_;
    NSMutableArray *_groupButtons_;
}

@synthesize identifier = _identifier_;
@synthesize maxButtonCount;
@synthesize delegate;
@synthesize sourceItems = _sourceItems_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    _groupButtons_ = [NSMutableArray array];
    self.maxButtonCount = 3;
    _selected_index_ = -1;
}

- (void)setSourceItems:(NSMutableArray *)sourceItems {
    // default setter
    _sourceItems_ = sourceItems;
    
    // clean up
    _selected_index_ = -1;
    
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [_groupButtons_ removeAllObjects];
    
    if(_sourceItems_.count < self.maxButtonCount) {
        self.maxButtonCount = _sourceItems_.count;
    }
    
    // create button group
    for(int i=0; i<self.maxButtonCount; i++) {
        SourceItem *sourceItem = [_sourceItems_ objectAtIndex:i];
        UIButton *btnRadio = [[UIButton alloc] initWithFrame:CGRectMake((85 * i), 0, 75, self.bounds.size.height)];
        btnRadio.backgroundColor = [UIColor whiteColor];
        btnRadio.layer.borderWidth = 1.f;
        btnRadio.tag = i;
        [btnRadio setTitle:sourceItem.displayName forState:UIControlStateNormal];
        [btnRadio setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnRadio addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0) {
            _selected_index_ = i;
            btnRadio.layer.borderColor = [UIColor orangeColor].CGColor;
        } else {
            btnRadio.layer.borderColor = [UIColor grayColor].CGColor;
        }
        [self addSubview:btnRadio];
        [_groupButtons_ addObject:btnRadio];
    }
}

- (void)setSelectedSourceItemViaDisplayName:(NSString *)displayName {
    if(self.sourceItems == nil) return;
    if([XXStringUtils isBlank:displayName]) return;
    for(int i=0; i<self.sourceItems.count; i++) {
        SourceItem *item = [self.sourceItems objectAtIndex:i];
        if([displayName isEqualToString:item.displayName]) {
            [self setSelectedItemViaIndex:i];
            return;
        }
    }
}

- (void)setSelectedSourceItemViaIdentifier:(NSString *)identifier {
    if(self.sourceItems == nil) return;
    if([XXStringUtils isBlank:identifier]) return;
    for(int i=0; i<self.sourceItems.count; i++) {
        SourceItem *item = [self.sourceItems objectAtIndex:i];
        if([identifier isEqualToString:item.identifier]) {
            [self setSelectedItemViaIndex:i];
            return;
        }
    }
}

- (void)setSelectedItemViaIndex:(int)index {
    if(index < -1) return;
    if(_selected_index_ == index) return;
    for(int i=0; i<_groupButtons_.count; i++) {
        UIButton *button = [_groupButtons_ objectAtIndex:i];
        if(index == i) {
            button.layer.borderColor = [UIColor orangeColor].CGColor;
        } else {
            button.layer.borderColor = [UIColor grayColor].CGColor;
        }
    }
    _selected_index_ = index;
}

- (void)btnPressed:(UIButton *)sender {
    if(_selected_index_ == sender.tag) return;
    for(int i=0; i<_groupButtons_.count; i++) {
        UIButton *button = [_groupButtons_ objectAtIndex:i];
        if(sender == button) {
            button.layer.borderColor = [UIColor orangeColor].CGColor;
        } else {
            button.layer.borderColor = [UIColor grayColor].CGColor;
        }
    }
    _selected_index_ = sender.tag;
    if(self.delegate != nil
       && [self.delegate respondsToSelector:@selector(radioRectButtonGroup:selectedSourceItem:)]) {
        SourceItem *item = [self.sourceItems objectAtIndex:_selected_index_];
        [self.delegate radioRectButtonGroup:self selectedSourceItem:item];
    }
}

- (SourceItem *)selectedSourceItem {
    if(_selected_index_ == -1) return nil;
    if(_selected_index_ >= self.sourceItems.count) return nil;
    return [self.sourceItems objectAtIndex:_selected_index_];
}

@end

@implementation SourceItem

@synthesize identifier = _identifier_;
@synthesize displayName = _displayName_;

- (instancetype)initWithIdentifier:(NSString *)identifier displayName:(NSString *)displayName {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.displayName = displayName;
    }
    return self;
}

@end
