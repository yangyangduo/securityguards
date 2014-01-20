//
//  UnitControlPanel.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXActionSheet.h"
#import "Unit.h"

@protocol UnitControlPanelDelegate;

@interface UnitControlPanel : UIView<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) id<UnitControlPanelDelegate> delegate;
@property (nonatomic, strong) Unit *unit;

- (instancetype)initWithPoint:(CGPoint)point;
- (instancetype)initWithPoint:(CGPoint)point andUnit:(Unit *)unit;

- (void)refreshWithUnit:(Unit *)unit;

@end

@protocol UnitControlPanelDelegate <NSObject>

- (void)unitControlPanelSizeChanged:(UnitControlPanel *)controlPanel;

@end
