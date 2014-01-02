//
//  UnitFinderResult.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitFinderResult.h"

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
