//
//  RadioRectButtonGroup.h
//  securityguards
//
//  Created by Zhao yang on 2/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SourceItem;

@protocol RadioRectButtonGroupDelegate;


@interface RadioRectButtonGroup : UIView

@property (nonatomic, weak) id<RadioRectButtonGroupDelegate> delegate;

@property (nonatomic, strong) NSString *identifier;
// default is three
@property (nonatomic, assign) unsigned int maxButtonCount;
@property (nonatomic, strong) NSMutableArray *sourceItems;

- (SourceItem *)selectedSourceItem;

- (void)setSelectedItemViaIndex:(int)index;
- (void)setSelectedSourceItemViaIdentifier:(NSString *)identifier;
- (void)setSelectedSourceItemViaDisplayName:(NSString *)displayName;

@end

@protocol RadioRectButtonGroupDelegate <NSObject>

- (void)radioRectButtonGroup:(RadioRectButtonGroup *)radioRectButtonGroup selectedSourceItem:(SourceItem *)sourceItem;

@end

@interface SourceItem : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *displayName;

- (instancetype)initWithIdentifier:(NSString *)identifier displayName:(NSString *)displayName;

@end
