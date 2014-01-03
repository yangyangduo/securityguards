//
//  CameraSocket.h
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"

@protocol CameraMessageDelegate <NSObject>

- (void)notifyNewImageWasReceived:(UIImage *)image;
- (void)notifyCameraConnectted;
- (void)notifyCameraWasDisconnectted;

@end

@interface CameraSocket : ClientSocket

@property (nonatomic, strong) NSString *key;
@property (nonatomic, weak) id<CameraMessageDelegate> delegate;

- (BOOL)isConnectted;
- (void)close;
- (void)closeGraceful;

@end
