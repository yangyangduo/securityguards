//
//  UnitFinder.h
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "UnitFinderResult.h"

@protocol UnitFinderDelegate<NSObject>

- (void)unitFinderOnResult:(UnitFinderResult *)result;

@end

@interface UnitFinder : NSObject<AsyncUdpSocketDelegate>

@property (nonatomic, weak) id<UnitFinderDelegate> delegate;

- (void)findUnit;

@end
