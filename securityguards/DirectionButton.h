//
//  DirectionButton.h
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionUpNone,
    DirectionUp,
    DirectionDown,
    DirectionLeft,
    DirectionRight
};

@protocol DirectionButtonDelegate <NSObject>

- (void)directionButtonClicked:(Direction)direction;

@end

@interface DirectionButton : UIView

@property (nonatomic, weak) id<DirectionButtonDelegate> delegate;

- (id)initWithPoint:(CGPoint)point;

@end
