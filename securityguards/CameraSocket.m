//
//  CameraSocket.m
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraSocket.h"
#import "BitUtils.h"
#import "XXStringUtils.h"

#define MAX_RETRY_COUNT 10
#define BUFFER_SIZE 4096

@implementation CameraSocket {
    NSString *connectionString;
    NSUInteger hasRetryCount;
    NSMutableData *currentImageData;
    NSUInteger currentImageLength;
    BOOL needToShakeHands;
    BOOL shakeHandsSuccess;
    BOOL needCloseSocket;
    BOOL inOpen;
    BOOL outOpen;
    
//    NSTimer *imageNotReceivedForLongTimeChecker;
//    NSLock *timeoutLock;
}

@synthesize delegate;

- (id)initWithIPAddress:(NSString *)ipAddress portNumber:(NSInteger)portNumber {
    self = [super initWithIPAddress:ipAddress portNumber:portNumber];
    if(self) {
//        timeoutLock = [[NSLock alloc] init];
        hasRetryCount = 0;
        shakeHandsSuccess = NO;
        needCloseSocket = NO;
        needToShakeHands = YES;
        inOpen = NO;
        outOpen = NO;
        currentImageLength = -1;
        currentImageData = [NSMutableData data];
    }
    return self;
}

@synthesize key = _key_;

#pragma mark -
#pragma mark socket

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if(eventCode == NSStreamEventHasBytesAvailable) {
        if(aStream != nil && aStream == self.inputStream) {
            if(!shakeHandsSuccess) {
                uint8_t header[1];
                NSInteger bytesRead = [self.inputStream read:header maxLength:1];
                if(bytesRead == -1) {
                    //unkonw, maybe server client was closed... don't need to process
                    return;
                }
                // shake hands success
                if(header[0] == 1) {
                    shakeHandsSuccess = YES;
//                    imageNotReceivedForLongTimeChecker = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(noImageReceivedForLongTime) userInfo:nil repeats:YES];
                } else {
                    [NSThread sleepForTimeInterval:1];
                    if(needCloseSocket) {
                        [self close];
                        self.delegate = nil;
                        return;
                    }
                    needToShakeHands = YES;
                    [self tryShakeHands];
                }
            } else {
                NSInteger bytesRead = 0;
                if(currentImageLength == -1) {
                    uint8_t dataLength[5-currentImageData.length];
                    bytesRead = [self.inputStream read:dataLength maxLength:5-currentImageData.length];
                    if(bytesRead != -1) {
                        [currentImageData appendBytes:dataLength length:bytesRead];
                    }
                    if(currentImageData.length == 5) {
                        uint8_t bytes[5];
                        [currentImageData getBytes:bytes length:5];
                        if(bytes[0] != 1) {
#ifdef DEBUG
                            NSLog(@"[TCP CAMERA SOCKET] header matching error");
#endif
                            [self close];
                            return;
                        }
                        currentImageLength = [BitUtils bytes2Int:bytes range:NSMakeRange(1, 4)];
                    }
                } else {
                    uint8_t dataDomain[BUFFER_SIZE];
                    NSUInteger remainBytes = currentImageLength - currentImageData.length;
                    bytesRead = [self.inputStream read:dataDomain maxLength:remainBytes >= BUFFER_SIZE ? BUFFER_SIZE : remainBytes];
                    if(bytesRead != -1) {
                        [currentImageData appendBytes:dataDomain length:bytesRead];
                    }
                    if(currentImageData.length == currentImageLength) {
                        [self performSelectorOnMainThread:@selector(notifyImageWasReady:) withObject:currentImageData waitUntilDone:YES];
                        currentImageLength = -1;
                        currentImageData = [NSMutableData data];
                    }
                }
            }
        }
    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
        [self tryShakeHands];
    } else if(eventCode == NSStreamEventOpenCompleted) {
        if(aStream == self.inputStream) {
            inOpen = YES;
        }
        if(aStream == self.outputStream) {
            outOpen = YES;
        }
        if(inOpen && outOpen) {
            [self performSelectorOnMainThread:@selector(notifyConnectionOpen) withObject:nil waitUntilDone:NO];
        }
    } else if(eventCode == NSStreamEventEndEncountered) {
#ifdef DEBUG
        NSLog(@"[TCP CAMERA SOCKET] Socket end encountered.");
#endif
        [self close];
    } else if(eventCode == NSStreamEventErrorOccurred) {
#ifdef DEBUG
        NSLog(@"[TCP CAMERA SOCKET] Socket error occurred.");
#endif
        [self close];
    } else if(eventCode == NSStreamEventNone) {
        //no event
    } else {
        //unknow event code , ignore this
    }
}

- (void)tryShakeHands {
    if(shakeHandsSuccess) return;
    @synchronized(self) {
        if(needToShakeHands) {
            needToShakeHands = NO;
            if([XXStringUtils isBlank:connectionString]) {
                [self close];
                return;
            }
            
            if(hasRetryCount >= MAX_RETRY_COUNT) {
                hasRetryCount = 0;
                [self close];
                return;
            }
            NSData *data = [connectionString dataUsingEncoding:NSUTF8StringEncoding];
            [self.outputStream write:data.bytes maxLength:data.length];
            hasRetryCount++;
        }
    }
}

/*
- (void)noImageReceivedForLongTime {
    if([timeoutLock tryLock]) {
        if(imageNotReceivedForLongTimeChecker != nil
           && imageNotReceivedForLongTimeChecker.isValid) {
            [self closeInternal];
#ifdef DEBUG
            NSLog(@"[CAMERA] Closed by timeout timer.");
#endif
        }
    }
}
*/

- (void)connect {
    if([self isConnectted]) return;
    [super connect];
}

/* 解决socket线程在睡眠等待的时候,被另外的线程close掉并释放内存,socket醒来后报错 */
- (void)closeGraceful {
    if(shakeHandsSuccess) {
        [self close];
        self.delegate = nil;
    } else {
        needCloseSocket = YES;
#ifdef DEBUG
        NSLog(@"[CAMERA] Will delay close.");
#endif
    }
}

- (void)close {
//    if([timeoutLock tryLock]) {
//        if(imageNotReceivedForLongTimeChecker != nil
//           && imageNotReceivedForLongTimeChecker.isValid) {
//            [imageNotReceivedForLongTimeChecker invalidate];
//        }
        [self closeInternal];
//    }
}

- (void)closeInternal {
    [super close];
    inOpen = NO;
    outOpen = NO;
    shakeHandsSuccess = NO;
    needToShakeHands = YES;
    currentImageLength = -1;
    currentImageData = [NSMutableData data];
    [self performSelectorOnMainThread:@selector(notifyConnectionClosed) withObject:nil waitUntilDone:NO];
}

- (BOOL)isConnectted {
    return inOpen && outOpen;
}

#pragma mark -
#pragma mark delegate

- (void)notifyImageWasReady:(NSData *)data {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyNewImageWasReceived:)]) {
        UIImage *image = [UIImage imageWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5 - 1)]];
        [self.delegate notifyNewImageWasReceived:image];
    }
}

- (void)notifyConnectionOpen {
     if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyCameraConnectted)]) {
         [self.delegate notifyCameraConnectted];
     }
}

- (void)notifyConnectionClosed {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyCameraWasDisconnectted)]) {
        [self.delegate notifyCameraWasDisconnectted];
    }
}

#pragma mark -
#pragma mark getter and setters

- (void)setKey:(NSString *)key {
    _key_ = key;
    if(_key_ != nil) {
        connectionString = [NSString stringWithFormat:@"%@sj", _key_];
    }
}

@end
