//
//  UnitFinder.h
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

typedef NS_ENUM(NSUInteger, UnitFinderResultType) {
    UnitFinderResultTypeSuccess,
    UnitFinderResultTypeFailed
};

@interface UnitFinderResult : NSObject

@property (nonatomic, assign) UnitFinderResultType resultType;
@property (nonatomic, strong) NSString *failedReason;
@property (nonatomic, strong) NSString *unitIdentifier;
@property (nonatomic, strong) NSString *unitUrl;

+ (id)errorWithReason:(NSString *)reason;
+ (id)successWithIdentifier:(NSString *)identifier andUrl:(NSString *)url;

@end

@implementation UnitFinderResult

@synthesize unitIdentifier;
@synthesize unitUrl;
@synthesize resultType;
@synthesize failedReason;

+ (id)errorWithReason:(NSString *)reason {
    UnitFinderResult *result = [[UnitFinderResult alloc] init];
    result.resultType = UnitFinderResultTypeFailed;
    result.failedReason = reason;
    return result;
}

+ (id)successWithIdentifier:(NSString *)identifier andUrl:(NSString *)url {
    UnitFinderResult *result = [[UnitFinderResult alloc] init];
    result.resultType = UnitFinderResultTypeSuccess;
    result.unitIdentifier = identifier;
    result.unitUrl = url;
    return result;
}

@end

@protocol UnitFinderDelegate<NSObject>

- (void)unitFinderOnResult:(UnitFinderResult *)result;

@end

@interface UnitFinder : NSObject<AsyncUdpSocketDelegate>

@property (nonatomic, weak) id<UnitFinderDelegate> delegate;

- (void)findUnit;

@end
