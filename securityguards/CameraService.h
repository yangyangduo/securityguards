//
//  CameraService.h
//  SmartHome
//
//  Created by Zhao yang on 10/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraSocket.h"
#import "ServiceBase.h"

@interface CameraService : ServiceBase

@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) id<CameraMessageDelegate> delegate;

- (id)initWithUrl:(NSString *)url;

- (void)open;
- (void)close;
- (BOOL)isPlaying;

- (void)dontNotifyMe;

@end
