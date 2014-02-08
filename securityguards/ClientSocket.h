//
//  ClientSocket.h
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientSocket : NSObject<NSStreamDelegate>

@property (nonatomic) int portNumber;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong, readonly) NSInputStream *inputStream;
@property (nonatomic, strong, readonly) NSOutputStream *outputStream;

- (instancetype)initWithIPAddress:(NSString *)ipAddress portNumber:(NSInteger)portNumber;

- (void)connect;
- (void)close;

@end
