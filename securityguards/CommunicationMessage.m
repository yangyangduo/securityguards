//
//  CommunicationMessage.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CommunicationMessage.h"
#import "CommandFactory.h"

@implementation CommunicationMessage

- (id)initWithDeviceCommand:(DeviceCommand *)command {
    self = [super init];
    if(self) {
        self.deviceCommand = command;
    }
    return self;
}

- (NSData *)generateData {
    if(self.deviceCommand == nil) return nil;
    
    NSMutableData *message = [NSMutableData data];
    
    // ******************
    // Process Heart Beat Command
    // Append heart beat command data header (This command is a special command, only send a byte what is 127.)
    // ******************
    if([COMMAND_SEND_HEART_BEAT isEqualToString:self.deviceCommand.commandName]) {
        [self addHeartBeatDataHeaderFor:message];
        return message;
    }
    
    //append data header
    [self addDataHeaderFor:message];
    
    NSData *dataDomain = [JsonUtils createJsonDataFromDictionary:[self.deviceCommand toDictionary]];
    
//#ifdef DEBUG
//    NSString *str = [[NSString alloc] initWithData:dataDomain encoding:NSUTF8StringEncoding];
//    NSLog(@"-----> %@", str);
//#endif
    
    //append data length
    NSUInteger totalLength = DATA_HEADER_LENGTH + DATA_LENGTH_LENGTH + DEVICE_NO_LENGTH + dataDomain.length + MD5_LENGTH;

    uint8_t dataLength[DATA_LENGTH_LENGTH];
    [BitUtils int2Bytes:totalLength bytes:dataLength];
    [message appendBytes:dataLength length:DATA_LENGTH_LENGTH];
    
    //append device number
    [self addDeviceNumberFor:message];

    //append message content
    [message appendData:dataDomain];
    
    //append md5
    [self addMD5Using:dataDomain for:(NSMutableData *)message];
    
    return message;
}

- (void)addHeartBeatDataHeaderFor:(NSMutableData *)message {
    uint8_t header[DATA_HEADER_LENGTH];
    header[0] = 127;
    [message appendBytes:header length:DATA_HEADER_LENGTH];
}

- (void)addDataHeaderFor:(NSMutableData *)message {
    uint8_t header[DATA_HEADER_LENGTH];
    header[0] = 126;
    [message appendBytes:header length:DATA_HEADER_LENGTH];
}

- (void)addDeviceNumberFor:(NSMutableData *)message {
    NSString *key = [NSString stringWithFormat:@"%@%@", self.deviceCommand.deviceCode, self.deviceCommand.appKey];
    [message appendData:[[NSString stringWithFormat:@"%@1", [XXStringUtils md5HexDigest:key]] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)addMD5Using:(NSData *)data for:(NSMutableData *)message {
    [message appendData:[[XXStringUtils md5HexDigest:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
