//
//  ExtranetClientSocket.h
//  SmartHome
//
//  Created by Zhao yang on 8/20/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"

@protocol MessageHandler <NSObject>

// message read error , and socket need close
- (void)clientSocketMessageReadError;

// only discard not valid message, socket should not be close
- (void)clientSocketMessageDiscard:(NSData *)discardMessage;

// success received message
- (void)clientSocketWithReceivedMessage:(NSData *)messages;

//
- (void)clientSocketSenderReady;


@optional

- (void)notifyConnectionClosed;
- (void)notifyConnectionOpened;
- (void)notifyConnectionTimeout;

@end

@interface ExtranetClientSocket : ClientSocket

@property (weak, nonatomic) id<MessageHandler> messageHandlerDelegate;
@property (assign, nonatomic, readonly) BOOL isConnect;

- (BOOL)canWrite;
- (BOOL)isConnectting;
- (void)writeData:(NSData *)data;

@end
