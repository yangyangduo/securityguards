//
//  UnitControlPanel.h
//  securityguards
//
//  Created by Zhao yang on 12/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Unit.h"

@protocol UnitControlPanelDelegate;

@interface UnitControlPanel : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<UnitControlPanelDelegate> delegate;
@property (nonatomic, strong) Unit *unit;

- (id)initWithPoint:(CGPoint)point;
- (id)initWithPoint:(CGPoint)point andUnit:(Unit *)unit;

@end

@protocol UnitControlPanelDelegate <NSObject>

- (void)unitControlPanelSizeChanged:(UnitControlPanel *)controlPanel;

@end
