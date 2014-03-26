//
//  UnitFinder.m
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitFinder.h"
#import "JsonUtils.h"
#import "SMNetworkTool.h"
#import "GlobalSettings.h"

#define MAX_BROADCAST_COUNT      50
#define BROADCAST_TIME_INTERVAL  3

@implementation UnitFinder {
    // UDP Socket
    AsyncUdpSocket *udpSocket;

    // received any broadcast response ?
    BOOL receivedAnyResponse;

    // address for UDP broadcast
    NSString *_broadcastAddress_;

    NSTimer *broadcastTimer;

    // record broadcast times
    int broadcastTimes;

    BOOL isFinding;
}

@synthesize delegate;

#pragma mark -
#pragma mark Service

- (void)startFinding {
    [self reset];

    // reset flag
    receivedAnyResponse = NO;

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

    // init broadcast address
    _broadcastAddress_ = [ipArr componentsJoinedByString:@"."];
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Local Ip is %@, Broadcast Address is %@", localIp, _broadcastAddress_);
#endif
    
    // init udp socket
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];

    // Broadcast to local network
    NSError *error;
    if([udpSocket enableBroadcast:YES error:&error]) {
        [self startBroadcastAppkey];
    } else {
        if(error != nil) {
            NSString *errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
#ifdef DEBUG
            NSLog(@"[UDP UNIT FINDER] Broadcast failed, Reason is [%@]", [XXStringUtils isBlank:errorMessage] ? [XXStringUtils emptyString] : errorMessage);
#endif
            [self findUnitOnError:[UnitFinderResult errorWithReason:errorMessage]];
        }
        [self reset];
    }
}

- (void)reset {
    isFinding = NO;

#ifdef DEBUG
    NSLog(@"[UNIT FINDER] Enter Reset.");
#endif

    // reset timer
    if(broadcastTimer != nil || broadcastTimer.isValid) {
        if(broadcastTimer.isValid) [broadcastTimer invalidate];
        broadcastTimer = nil;
#ifdef DEBUG
        NSLog(@"[UNIT FINDER] Timer Closed.");
#endif
    }

    // reset socket
    if(udpSocket != nil) {
        if(udpSocket.isConnected || !udpSocket.isClosed) {
            [udpSocket closeAfterSendingAndReceiving];
        }
#ifdef DEBUG
        NSLog(@"[UNIT FINDER] UDP Socket Closing...");
#endif
    }

    // reset address
    _broadcastAddress_ = nil;
}

- (void)startBroadcastAppkey {
    isFinding = YES;
    broadcastTimes = 0;
    broadcastTimer = [NSTimer scheduledTimerWithTimeInterval:BROADCAST_TIME_INTERVAL target:self selector:@selector(broadcastAppKey) userInfo:nil repeats:YES];
}

- (void)broadcastAppKey {
    if(!isFinding) return;
    if(receivedAnyResponse || broadcastTimes >= MAX_BROADCAST_COUNT) {
        [self reset];
        return;
    }
    [udpSocket receiveWithTimeout:3 tag:0];
    if([udpSocket enableBroadcast:YES error:nil]) {
        [udpSocket sendData:[self generateBroadcastMessage] toHost:_broadcastAddress_ port:5050 withTimeout:3 tag:1];
    }
    broadcastTimes++;
#ifdef DEBUG
    NSLog(@"Will broadcast app key [%@] on times %d", APP_KEY, broadcastTimes);
#endif
}

- (NSData *)generateBroadcastMessage {
    static NSData *data = nil;
    if(data == nil) {
        data = [APP_KEY dataUsingEncoding:NSUTF8StringEncoding];
    }
    return data;
}

#pragma mark-
#pragma mark UDP Delegate

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
    if(!isFinding) return NO;
    if(receivedAnyResponse) {
        return NO;
    }
    receivedAnyResponse = YES;
    NSDictionary *json =[JsonUtils createDictionaryFromJson:data];
    if(json == nil) {
        [self findUnitOnError:[UnitFinderResult errorWithReason:@"No response data."]];
        return NO;
    }
    NSString *unitIdentifier = [json noNilStringForKey:@"deviceCode"];
    NSString *unitUrl = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg",[json noNilStringForKey:@"ipv4"], 8777];
    [self reset];
#ifdef DEBUG
    NSLog(@"[Unit Finder] Receive response %@ -- %@", unitIdentifier, unitUrl);
#endif
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(unitFinderOnResult:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate unitFinderOnResult:[UnitFinderResult successWithIdentifier:unitIdentifier andUrl:unitUrl]];
        });
    }
    return  NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    if(!isFinding) return;
    [self reset];
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
    if(!receivedAnyResponse) {
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