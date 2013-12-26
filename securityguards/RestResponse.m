//
//  RestResponse.m
//  topsales
//
//  Created by young on 4/10/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "RestResponse.h"

@implementation RestResponse

@synthesize statusCode=_statusCode;
@synthesize body=_body;
@synthesize headers=_headers;
@synthesize failedReason=_failedReason;
@synthesize contentType=_contentType;
@synthesize callbackObject=_callbackObject;

@end
