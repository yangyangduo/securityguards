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

@property (nonatomic, weak) id<MessageHandler> messageHandlerDelegate;
@property (nonatomic, assign, readonly) BOOL isConnectted;
@property (nonatomic, assign, readonly) BOOL isConnectting;
@property (nonatomic, assign, readonly) BOOL canWrite;

- (void)writeData:(NSData *)data;

@end
