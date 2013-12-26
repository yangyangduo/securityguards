//
//  SMNotification.m
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMNotification.h"
#import "SMDateFormatter.h"

@implementation SMNotification

@synthesize text;
@synthesize type;
@synthesize typeName;
@synthesize mac;
@synthesize createTime;
@synthesize data = _data;
@synthesize hasRead;
@synthesize hasProcess;
@synthesize identifier;

@synthesize isInfo;
@synthesize isValidation;
@synthesize isMessage;
@synthesize isWarning;
@synthesize isInfoOrMessage;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.text = [json stringForKey:@"text"];
        self.mac = [json stringForKey:@"mac"];
        self.type = [json stringForKey:@"type"];
        self.createTime = [json dateForKey:@"createTime"];
        self.identifier = [json stringForKey:@"id"];
        self.hasRead = [json boolForKey:@"hasRead"];
        self.hasProcess = [json boolForKey:@"hasProcess"];
        NSDictionary *_data_ = [json dictionaryForKey:@"data"];
        if(_data_ != nil) {
            self.data = [[NotificationData alloc] initWithJson:_data_];
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setMayBlankString:self.text forKey:@"text"];
    [json setMayBlankString:self.mac forKey:@"mac"];
    [json setMayBlankString:self.type forKey:@"type"];
    [json setMayBlankString:self.identifier forKey:@"id"];
    [json setBool:self.hasProcess forKey:@"hasProcess"];
    [json setBool:self.hasRead forKey:@"hasRead"];
    [json setDateLongLongValue:self.createTime forKey:@"createTime"];
    
    if(self.data != nil) {
        [json setObject:[self.data toJson] forKey:@"data"];
    }
    
    return json;
}

- (NSString *)typeName {
    if([XXStringUtils isBlank:self.type]) return [XXStringUtils emptyString];
    return NSLocalizedString(self.type.lowercaseString, @"");
}

- (BOOL)isWarning {
    if([XXStringUtils isBlank:self.type]) return NO;
    return  [@"AL" isEqualToString:self.type];
}

- (BOOL)isValidation {
    if([XXStringUtils isBlank:self.type]) return NO;
    return  [@"CF" isEqualToString:self.type];
}

- (BOOL)isInfo {
    if([XXStringUtils isBlank:self.type]) return NO;
    return  [@"AT" isEqualToString:self.type];
}

- (BOOL)isMessage {
    if([XXStringUtils isBlank:self.type]) return NO;
    return  [@"MS" isEqualToString:self.type];
}

- (BOOL)isInfoOrMessage {
    return self.isMessage || self.isInfo;
}

@end
