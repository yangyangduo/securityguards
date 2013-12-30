//
//  ExtranetClientSocket.m
//  SmartHome
//
//  Created by Zhao yang on 8/20/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ExtranetClientSocket.h"
#import "CommunicationMessage.h"

#define BUFFER_SIZE 1024
#define TIME_OUT    12

@implementation ExtranetClientSocket {
    /*
     * socket received data
     */
    NSMutableData *receivedData;
    
    BOOL inOpen;
    BOOL outOpen;
    
    NSTimer *timeoutTimer;
}

@synthesize messageHandlerDelegate;
@synthesize isConnectted;
@synthesize isConnectting;
@synthesize canWrite;


#pragma mark -
#pragma mark Socket Connection

- (void)connect {
    /*     init defaults     */
    if(receivedData != nil) {
        receivedData = nil;
    }
    if(timeoutTimer != nil) {
        if(timeoutTimer.isValid) {
            [timeoutTimer invalidate];
        }
        timeoutTimer = nil;
    }
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_OUT target:self selector:@selector(connectTimeout) userInfo:nil repeats:NO];
    [super connect];
}

- (void)connectTimeout {
    if(!self.isConnectted) {
        [self close];
        if(self.messageHandlerDelegate != nil && [self.messageHandlerDelegate respondsToSelector:@selector(notifyConnectionTimeout)]) {
            [self.messageHandlerDelegate notifyConnectionTimeout];
        }
    } else {
        timeoutTimer = nil;
    }
}

- (BOOL)isConnectted {
    return inOpen && outOpen;
}

- (BOOL)isConnectting {
    return (self.inputStream != nil && self.inputStream.streamStatus == NSStreamStatusOpening)
    || (self.outputStream != nil && self.outputStream.streamStatus == NSStreamStatusOpening);
}

- (BOOL)canWrite {
    return self.outputStream.hasSpaceAvailable;
}

- (void)writeData:(NSData *)data {
    [self.outputStream write:data.bytes maxLength:data.length];
}

#pragma mark -
#pragma mark Socket Close

- (void)close {
    if(timeoutTimer != nil) {
        if(timeoutTimer.isValid) {
            [timeoutTimer invalidate];
        }
        timeoutTimer = nil;
    }
    receivedData = nil;
    [super close];
    inOpen = NO;
    outOpen = NO;
    if(self.messageHandlerDelegate != nil && [self.messageHandlerDelegate respondsToSelector:@selector(notifyConnectionClosed)]) {
        [self.messageHandlerDelegate notifyConnectionClosed];
    }
}

#pragma mark -
#pragma mark Data processes

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
     if(eventCode == NSStreamEventHasBytesAvailable) {
        if(aStream != nil && aStream == self.inputStream) {
            
            //initialization data
            if(receivedData == nil) {
                receivedData = [NSMutableData data];
            }
            
            //read header data (one byte)
            uint8_t header[DATA_HEADER_LENGTH];
            NSInteger bytesRead = [self.inputStream read:header maxLength:DATA_HEADER_LENGTH];
            if(bytesRead != DATA_HEADER_LENGTH) {
                //unkonw, maybe server client was closed...
                return;
            }
            
            // should be ignore
            // this is heart beat message
            if(header[0] == 127) {
#ifdef DEBUG
                NSLog(@"[External Socket] Received heart beat message.");
#endif
                if(!self.inputStream.hasBytesAvailable) {
                    return;
                }
#ifdef DEBUG
                NSLog(@"[External Socket] Has bytes after heart beat message.");
#endif
                bytesRead = [self.inputStream read:header maxLength:DATA_HEADER_LENGTH];
                
                if(bytesRead != DATA_HEADER_LENGTH) {
                    //unkonw, maybe server client was closed...
                    return;
                }
            }
            
            //header data was matched
            if(header[0] == 126) {
                if(receivedData.length != 0) {
                    //will discard received data before
                    //i think this is a new package
                    [self performSelectorOnMainThread:@selector(notifyHandlerDataDiscard:) withObject:receivedData waitUntilDone:NO];
                    receivedData = [NSMutableData data];
#ifdef DEBUG
                    NSLog(@"[External Socket] Received header [~] and old message isn't process successfully, so need to give up some data that we have received before .");
#endif
                }
                [receivedData appendBytes:header length:DATA_HEADER_LENGTH];
                [self readAllDataToMemory];
            } else {
                if(receivedData.length != 0) {
                    //append data
                    [receivedData appendBytes:header length:DATA_HEADER_LENGTH];
                    [self readAllDataToMemory];
                } else {
                    //this is a bad request, header data was not matched
                    //and has never received data before
                    [self performSelectorOnMainThread:@selector(notifyHandlerDataError) withObject:nil waitUntilDone:NO];
                    [self close];
#ifdef DEBUG
                    NSLog(@"[External Socket] Data header is not matched [~] 126 .");
#endif
                    return;
                }
            }
            
            //all data from input stream has been writted to the memory
            //and then process it
            [self processReceivedData];
        }
    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
        if(aStream == self.outputStream) {
            if([self.messageHandlerDelegate respondsToSelector:@selector(clientSocketSenderReady)]) {
                [self.messageHandlerDelegate clientSocketSenderReady];
            }
        }
    } else if(eventCode == NSStreamEventOpenCompleted) {
        if(aStream == self.inputStream) {
            inOpen = YES;
        } else if(aStream == self.outputStream) {
            outOpen = YES;
        }
        if(inOpen && outOpen) {
            if(self.messageHandlerDelegate != nil && [self.messageHandlerDelegate respondsToSelector:@selector(notifyConnectionOpened)]) {
                [self.messageHandlerDelegate notifyConnectionOpened];
            }
        }
    } else if(eventCode == NSStreamEventEndEncountered) {
        [self close];
    } else if(eventCode == NSStreamEventErrorOccurred) {
        [self close];
    } else if(eventCode == NSStreamEventNone) {
        //no event
    } else {
        //unknow event code , ignore this
    }
}

- (void)readAllDataToMemory {
    uint8_t buffer[BUFFER_SIZE];
    while(self.inputStream != nil && self.inputStream.hasBytesAvailable) {
        NSInteger bytesHasRead = [self.inputStream read:buffer maxLength:BUFFER_SIZE];
        if(bytesHasRead != -1) {
            [receivedData appendBytes:buffer length:bytesHasRead];
        }
    }
}

- (void)processReceivedData {
    if(receivedData == nil || receivedData.length == 0) return;
    if(receivedData.length > 5) {
        uint8_t bytes[5];
        [receivedData getBytes:bytes length:5];
        if(bytes[0] == 126) {
            NSUInteger messageTotalLength = [BitUtils bytes2Int:bytes range:NSMakeRange(1, 4)];
            if(receivedData.length >= messageTotalLength) {
                NSData *dataMessage = [receivedData subdataWithRange:NSMakeRange(5, messageTotalLength-5)];
                [self unPackageMessage:dataMessage];
                if(receivedData.length > messageTotalLength) {
                    //more than one message, need continue to process received data
                    receivedData = [NSMutableData dataWithData:[receivedData subdataWithRange:NSMakeRange(messageTotalLength, receivedData.length - messageTotalLength)]];
                    [self processReceivedData];
                } else if(receivedData.length == messageTotalLength) {
                    receivedData = [NSMutableData data];
                }
            } else {
                // less than one message , continue to watting for input stream
            }
        } else {
            
            if(bytes[0] == 127) {
#ifdef DEBUG
                NSLog(@"[External Socket] Heart beat byte is in message.");
#endif
                receivedData = [NSMutableData dataWithData:[receivedData subdataWithRange:NSMakeRange(1, receivedData.length - 1)]];
                [self processReceivedData];
                return;
            }
            
            //data header error
            //need to handle this error
            [self performSelectorOnMainThread:@selector(notifyHandlerDataError) withObject:nil waitUntilDone:NO];
            [self close];
#ifdef DEBUG
            NSLog(@"[External Socket] Data header is not matched [!] 126 on unpackage data.");
#endif
        }
    } else {
        //don't need to process , continue to watting for input stream
        
        if(receivedData.length == 1) {
            uint8_t bytes[1];
            [receivedData getBytes:bytes length:1];
            if(bytes[0] == 127) {
                receivedData = [NSMutableData data];
#ifdef DEBUG
                NSLog(@"[External Socket] Give up heart beat message.");
#endif
            }
        }
    }
}

- (void)unPackageMessage:(NSData *)data {
    //17 is the length of device code
    //16 is the length of md5 string
    //others is the content length
    if(data.length > 17 + 16) {
//        NSData *data_device_no = [data subdataWithRange:NSMakeRange(0, 17)];
        NSData *data_body = [data subdataWithRange:NSMakeRange(17, data.length - 17 - 16)];
        NSData *data_md5 = [data subdataWithRange:NSMakeRange(data.length - 16, 16)];
        
        NSString *messageBody = [[NSString alloc] initWithData:data_body encoding:NSUTF8StringEncoding];
        NSString *md5Str = [[NSString alloc] initWithData:data_md5 encoding:NSUTF8StringEncoding];
        
        if([[XXStringUtils md5HexDigest:messageBody] isEqualToString:md5Str]) {
            //good message
            [self performSelectorOnMainThread:@selector(notifyHandlerMessageReceived:) withObject:data_body waitUntilDone:NO];
        } else {
            //bad message , not valid from md5
            [self performSelectorOnMainThread:@selector(notifyHandlerDataDiscard:) withObject:data waitUntilDone:NO];
#ifdef DEBUG
            NSLog(@"[External Socket] Data not valid by MD5.");
#endif
        }
    } else {
        //message is too small (less than one byte...), need discard this message
        [self performSelectorOnMainThread:@selector(notifyHandlerDataDiscard:) withObject:data waitUntilDone:NO];
#ifdef DEBUG
        NSLog(@"[External Socket] Data is too small.");
#endif
    }
}

#pragma mark -
#pragma mark message handler delegate

- (void)notifyHandlerDataError {
    if(self.messageHandlerDelegate != nil) {
        if([self.messageHandlerDelegate respondsToSelector:@selector(clientSocketMessageReadError)]) {
            [self.messageHandlerDelegate clientSocketMessageReadError];
        }
    }
}

- (void)notifyHandlerDataDiscard:(NSData *)data {
    if(self.messageHandlerDelegate != nil) {
        if([self.messageHandlerDelegate respondsToSelector:@selector(clientSocketMessageDiscard:)]) {
            [self.messageHandlerDelegate clientSocketMessageDiscard:data];
        }
    }
}

- (void)notifyHandlerMessageReceived:(NSData *)message {
    if(self.messageHandlerDelegate != nil) {
        if([self.messageHandlerDelegate respondsToSelector:@selector(clientSocketWithReceivedMessage:)]) {
            [self.messageHandlerDelegate clientSocketWithReceivedMessage:message];
        }
    }
}

@end
