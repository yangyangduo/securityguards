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

@synthesize portNumber = _portNumber_;
@synthesize ipAddress = _ipAddress_;
@synthesize inputStream = _inputStream_;
@synthesize outputStream = _outputStream_;

- (instancetype)initWithIPAddress:(NSString *)ipAddress portNumber:(NSInteger)portNumber {
    self = [super init];
    if(self) {
        _ipAddress_ = ipAddress;
        _portNumber_ = portNumber;
    }
    return self;
}

- (void)connect {
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;

    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.ipAddress, self.portNumber, &readStream, &writeStream);

    _inputStream_ = CFBridgingRelease(readStream);
    _outputStream_= CFBridgingRelease(writeStream);

    _inputStream_.delegate = self;
    _outputStream_.delegate = self;
    
    [_inputStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream_ open];
    [_outputStream_ open];
    
    [[NSRunLoop currentRunLoop] run];
    
#ifdef DEBUG
    NSLog(@"[CLIENT SOCKET] Run Loops Ended.");
#endif
}

- (void)close {
    if(_inputStream_ != nil) {
        [_inputStream_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        if(_inputStream_.streamStatus != NSStreamStatusNotOpen && _inputStream_.streamStatus != NSStreamStatusClosed) {
            [_inputStream_ close];
        }
        _inputStream_ = nil;
    }
    if(_outputStream_ != nil) {
        [_outputStream_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        if(_outputStream_.streamStatus != NSStreamStatusNotOpen && _outputStream_.streamStatus != NSStreamStatusClosed) {
            [_outputStream_ close];
        }
        _outputStream_ = nil;
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
