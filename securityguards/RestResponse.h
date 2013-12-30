//
//  RestResponse.h
//  topsales
//
//  Created by young on 4/10/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestResponse : NSObject

@property(nonatomic, assign) int statusCode;
@property(nonatomic, strong) NSData *body;
@property(nonatomic, strong) NSString *failedReason;
@property(nonatomic, strong) NSString *contentType;
@property(nonatomic, strong) NSDictionary *headers;
@property(nonatomic, strong) id callbackObject;

@end
