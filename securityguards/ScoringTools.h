//
//  ScoringTools.h
//  securityguards
//
//  Created by Zhao yang on 8/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"

@interface ScoringTools : NSObject

+ (NSNumber *)scoringForUnit:(Unit *)unit;
+ (float)rankingForScore:(float)score;

@end
