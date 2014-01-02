//
//  UnitFinderResult.h
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

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
