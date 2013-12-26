//
//  CameraPicPath.h
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface CameraPicPath : Entity

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *host;

@end
