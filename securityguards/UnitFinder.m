//
//  UnitFinder.m
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitFinder.h"
#import "AsyncUdpSocket.h"
#import "JsonUtils.h"
#import "SMNetworkTool.h"
#import "NSDictionary+Extension.h"

#define APP_KEY @"A001"

@implementation UnitFinder {
    BOOL hasReceivedData;
}

@synthesize delegate;

#pragma mark -
#pragma mark Service

- (void)findUnit {
    hasReceivedData = NO;
    
    // Get local ip
    NSString *localIp = [SMNetworkTool getLocalIp];
    
    if([XXStringUtils isBlank:localIp]) {
        [self findUnitOnError:[UnitFinderResult errorWithReason:@"Get local ip failed."]];
        return;
    }
    
    // Get broadcast address
    NSMutableArray *ipArr = [NSMutableArray arrayWithArray:[localIp componentsSeparatedByString:@"."]];
    [ipArr removeLastObject];
    [ipArr addObject:@"255"];
    NSString *broadCastAddress = [ipArr componentsJoinedByString:@"."];
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Local Ip is %@, Broadcast Address is %@", localIp, broadCastAddress);
#endif
    
    // Initial udp socket
    AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    // Broadcast to local network
    NSError *error;
    if([udpSocket enableBroadcast:YES error:&error]) {
        [udpSocket sendData:[self generateBroadcastMessage] toHost:broadCastAddress port:5050 withTimeout:5 tag:1];
        [udpSocket receiveWithTimeout:5 tag:0];
    } else {
        if(error != nil) {
#ifdef DEBUG
            NSString *errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
            NSLog(@"[UDP UNIT FINDER] Broadcast failed, Reason is [%@]", [XXStringUtils isBlank:errorMessage] ? [XXStringUtils emptyString] : errorMessage);
#endif
            [self findUnitOnError:[UnitFinderResult errorWithReason:errorMessage]];
        }
    }
    [udpSocket closeAfterReceiving];
}

- (NSData *)generateBroadcastMessage {
    return [APP_KEY dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark-
#pragma mark UDP Delegate

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
    hasReceivedData = YES;
    NSDictionary *json =[JsonUtils createDictionaryFromJson:data];
    if(json == nil) {
        [self findUnitOnError:[UnitFinderResult errorWithReason:@"No response data."]];
        return NO;
    }
    NSString *unitIdentifier = [json noNilStringForKey:@"deviceCode"];
    NSString *unitUrl = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg",[json noNilStringForKey:@"ipv4"], 8777];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(unitFinderOnResult:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate unitFinderOnResult:[UnitFinderResult successWithIdentifier:unitIdentifier andUrl:unitUrl]];
        });
    }
    return  NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSString *errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Broadcast(on udp socket) message failed, Reason is [%@]", [XXStringUtils isBlank:errorMessage] ? [XXStringUtils emptyString] : errorMessage);
#endif
    
    [self findUnitOnError:[UnitFinderResult errorWithReason:errorMessage]];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Broadcast message successfully.");
#endif
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock {
    if(!hasReceivedData) {
        [self findUnitOnError:[UnitFinderResult errorWithReason:@"Udp socket closed."]];
    }
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Closed.");
#endif
}

- (void)findUnitOnError:(UnitFinderResult *)result {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(unitFinderOnResult:)]) {
        if(![NSThread currentThread].isMainThread) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.delegate unitFinderOnResult:result];
            });
        } else {
            [self.delegate unitFinderOnResult:result];
        }
    }
}

@end
