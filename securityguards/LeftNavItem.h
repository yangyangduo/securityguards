//
//  LeftNavItem.h
//  securityguards
//
//  Created by Zhao yang on 12/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftNavItem : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *imageName;

- (id)initWithIdentifier:(NSString *)identifier andDisplayName:(NSString *)displayName andImageName:(NSString *)imageName;

@end
