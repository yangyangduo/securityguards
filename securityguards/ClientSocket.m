//
//  ClientSocket.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"

@implementation ClientSocket {
}

@synthesize ipAddress;
@synthesize port;
@synthesize inputStream;
@synthesize outputStream;

+ (NSThread *)socketThread {
    static NSThread *_socketThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _socketThread = [[NSThread alloc] initWithTarget:self selector:@selector(socketEntryPoint) object:nil];
        [_socketThread start];
    });
    return _socketThread;
}

+ (void)socketEntryPoint {
    [[NSThread currentThread] setName:@"ClientSocket"];
        
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (instancetype)initWithIPAddress:(NSString *)ip andPort:(NSInteger)portNumber {
    self = [super init];
    if(self) {
        self.ipAddress = ip;
        self.port = portNumber;
    }
    return self;
}

- (void)connect {
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;

    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.ipAddress, self.port, &readStream, &writeStream);

    inputStream = CFBridgingRelease(readStream);
    outputStream = CFBridgingRelease(writeStream);

    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    [[NSRunLoop currentRunLoop] run];
}

- (void)close {
    if(inputStream != nil) {
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        if(inputStream.streamStatus != NSStreamStatusNotOpen && inputStream.streamStatus != NSStreamStatusClosed) {
            [inputStream close];
        }
        inputStream = nil;
    }
    if(outputStream != nil) {
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        if(outputStream.streamStatus != NSStreamStatusNotOpen && outputStream.streamStatus != NSStreamStatusClosed) {
            [outputStream close];
        }
        outputStream = nil;
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if(eventCode == NSStreamEventNone) {
        // ignore this event
    } else if(eventCode == NSStreamEventOpenCompleted) {
        // stream is opened
    } else if(eventCode == NSStreamEventEndEncountered) {
        [self close];
    } else if(eventCode == NSStreamEventErrorOccurred) {
        [self close];
    } else if(eventCode == NSStreamEventHasBytesAvailable) {
        // has bytes available
    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
        // has space available , can writer data to output stream
    } else {
        // unknow event code
    }
}

@end
