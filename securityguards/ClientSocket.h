//
//  ClientSocket.h
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientSocket : NSObject<NSStreamDelegate>

@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic, readonly) NSInputStream *inputStream;
@property (strong, nonatomic, readonly) NSOutputStream *outputStream;
@property (assign, nonatomic) NSInteger port;

- (id)initWithIPAddress:(NSString *)ip andPort:(NSInteger)portNumber;

- (void)connect;
- (void)close;

@end
