//
//  RestClient.m
//  topsales
//
//  Created by young on 4/10/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "RestClient.h"

@implementation RestClient {
    @private NSString *authKey;
}

@synthesize authName=_authName, authPassword=_authPassword, baseUrl=_baseUrl,
timeoutInterval=_timeoutInterval, auth=_auth;

+ (NSOperationQueue *)restOperationQueue {
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 2;
    });
    return queue;
}

#pragma mark -
#pragma mark Initializations

- (id)initWithBaseUrl:(NSString *)u {
    self = [super init];
    if(self) {
        self.baseUrl = u;
        self.auth = AuthenticationTypeNone;
    }
    return self;
}

- (id)initWithBaseUrl:(NSString *)u authName:(id)n authPassword:(id)p authType:(AuthenticationType)a {
    self = [[RestClient alloc] init];
    if(self) {
        self.baseUrl = u;
        self.authName = n;
        self.authPassword = p;
        self.auth = a;
    }
    return self;
}

#pragma mark -
#pragma mark Classic Style

- (void)getForUrl:(NSString *)u acceptType:(NSString *)a success : (SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    NSDictionary *headers = nil;
    if(a != nil) {
        headers = [NSDictionary dictionaryWithObjectsAndKeys:a, @"Accept", nil];
    }
    [self executeForUrl:u method:@"GET" headers:headers body : nil success:s error:e for:obj callback:cb];
}

- (void)postForUrl:(NSString *)u acceptType:(NSString *)a contentType:(id)c body:(NSData *)b success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    NSMutableDictionary *headers = nil;
    if(a != nil || c != nil) {
        headers = [[NSMutableDictionary alloc] init];
        if(c != nil) {
            [headers setObject:c forKey:@"Content-Type"];
        }
        if(a != nil) {
            [headers setObject:a forKey:@"Accept"];
        }
    }
    [self executeForUrl:u method:@"POST" headers:headers body:b success:s error:e for:obj callback:cb];
}

- (void)putForUrl:(NSString *)u acceptType:(NSString *)a contentType:(NSString *)c body:(NSData *)b success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    NSMutableDictionary *headers = nil;
    if(a != nil || c != nil) {
        headers = [[NSMutableDictionary alloc] init];
        if(c != nil) {
            [headers setObject:c forKey:@"Content-Type"];
        }
        if(a != nil) {
            [headers setObject:a forKey:@"Accept"];
        }
    }
    [self executeForUrl:u method:@"PUT" headers:headers body:b success:s error:e for:obj callback:cb];
}

- (void)deleteForUrl:(NSString *)u success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    [self executeForUrl:u method:@"DELETE" headers:nil body:nil success:s error:e for:obj callback:cb];
}

- (void)executeForUrl:(NSString *)u method:(NSString *)m headers:(NSDictionary *)h body : (NSData *) b success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    @try {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [self getFullUrl:u] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeoutInterval];
        request.HTTPMethod = m;
        if(h != nil) {
            request.allHTTPHeaderFields = h;
            if(self.auth == AuthenticationTypeBasic) {
                if(authKey == nil) {
                    authKey = [XXStringUtils stringEncodeWithBase64:[NSString stringWithFormat:@"%@:%@", self.authName, self.authPassword]];
                }
                [request setValue:[NSString stringWithFormat:@"Basic %@", authKey] forHTTPHeaderField:@"Authorization"];
            }
        }
        request.HTTPBody = b;
        
        __weak __typeof(obj) wTarget = obj;
        [NSURLConnection sendAsynchronousRequest:request queue:[[self class] restOperationQueue]
                               completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
                                   RestResponse *response = [[RestResponse alloc] init];
                                   if(error == nil) {
                                       if(wTarget != nil && s != nil) {
                                           __strong __typeof__(obj) sobj = wTarget;
                                           if([sobj respondsToSelector:s]) {
                                               if([resp isMemberOfClass:[NSHTTPURLResponse class]]) {
                                                   NSHTTPURLResponse *rp = (NSHTTPURLResponse *)resp;
                                                   response.statusCode = rp.statusCode;
                                                   response.body = data;
                                                   response.callbackObject = cb;
                                                   response.contentType = [rp.allHeaderFields valueForKey:@"Content-Type"];
                                                   response.headers = rp.allHeaderFields;
                                                   [sobj performSelectorOnMainThread:s withObject:response waitUntilDone:NO];
                                               }
                                           }
                                       }
                                   } else {
                                       if(wTarget != nil && e != nil) {
                                           __strong __typeof__(obj) sobj = wTarget;
                                           if([sobj respondsToSelector:e]) {
                                               response.statusCode = error.code;
                                               response.failedReason = error.localizedFailureReason;
                                               [sobj performSelectorOnMainThread:e withObject:response waitUntilDone:NO];
                                           }
                                       }
                                   }
                               }];
    } @catch (NSException *ex) {
        RestResponse *response = [[RestResponse alloc] init];
        response.statusCode = 500; //Server internal error
        response.failedReason = ex.reason;
        [obj performSelectorOnMainThread:e withObject:response waitUntilDone:NO];
    }
}

#pragma mark -
#pragma mark Block Style

- (void)get:(NSString *)url acceptType:(NSString *)acceptType success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error {
    NSDictionary *headers = nil;
    if(acceptType != nil) {
        headers = [NSDictionary dictionaryWithObjectsAndKeys:acceptType, @"Accept", nil];
    }
    [self execute:url method:@"GET" headers:headers body:nil success:success error:error];
}

- (void)post:(NSString *)url acceptType:(NSString *)acceptType contentType:(NSString *)contentType body:(NSData *)body success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error {
    NSMutableDictionary *headers = nil;
    if(acceptType != nil || contentType != nil) {
        headers = [[NSMutableDictionary alloc] init];
        if(contentType != nil) {
            [headers setObject:contentType forKey:@"Content-Type"];
        }
        if(acceptType != nil) {
            [headers setObject:acceptType forKey:@"Accept"];
        }
    }
    [self execute:url method:@"POST" headers:headers body:body success:success error:error];
}

- (void)put:(NSString *)url acceptType:(NSString *)acceptType contentType:(NSString *)contentType body:(NSData *)body success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error {
    NSMutableDictionary *headers = nil;
    if(acceptType != nil || contentType != nil) {
        headers = [[NSMutableDictionary alloc] init];
        if(contentType != nil) {
            [headers setObject:contentType forKey:@"Content-Type"];
        }
        if(acceptType != nil) {
            [headers setObject:acceptType forKey:@"Accept"];
        }
    }
    [self execute:url method:@"PUT" headers:headers body:body success:success error:error];

}

- (void)delete:(NSString *)url success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error {
    [self execute:url method:@"DELETE" headers:nil body:nil success:success error:error];
}

- (void)execute:(NSString *)u method:(NSString *)m headers:(NSDictionary *)h body:(NSData *)b success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))err {
    @try {
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL: [self getFullUrl:u] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeoutInterval];
        request.HTTPMethod = m;
        if(h != nil) {
            request.allHTTPHeaderFields = h;
            if(self.auth == AuthenticationTypeBasic) {
                if(authKey == nil) {
                    authKey = [XXStringUtils stringEncodeWithBase64:[NSString stringWithFormat:@"%@:%@", self.authName, self.authPassword]];
                }
                [request setValue:[NSString stringWithFormat:@"Basic %@", authKey] forHTTPHeaderField:@"Authorization"];
            }
        }
        request.HTTPBody = b;
        
        NSHTTPURLResponse *rp;
        NSError *error;
        NSData *body = [NSURLConnection sendSynchronousRequest:request returningResponse:&rp error:&error];
        RestResponse *response = [[RestResponse alloc] init];
        if(error == nil && body != nil) {
            response.statusCode = rp.statusCode;
            response.body = body;
            response.contentType = [rp.allHeaderFields valueForKey:@"Content-Type"];
            response.headers = rp.allHeaderFields;
            success(response);
        } else {
            response.statusCode = error.code;
            response.failedReason = error.localizedFailureReason;
            err(response);
        }
    } @catch (NSException *ex) {
        RestResponse *response = [[RestResponse alloc] init];
        response.statusCode = 500; //Server internal error
        response.failedReason = ex.reason;
        err(response);
    }
}

- (NSInteger)timeoutInterval {
    if(_timeoutInterval <= 0) {
        _timeoutInterval = 15;
    }
    return _timeoutInterval;
}

- (NSURL *)getFullUrl:(NSString *)relativeUrl {
    if([XXStringUtils isBlank:relativeUrl]) return [[NSURL alloc] initWithString:self.baseUrl];
    if([XXStringUtils isBlank:self.baseUrl]) return [[NSURL alloc] initWithString:relativeUrl];
    
    BOOL hasEnd;
    BOOL hasStart;
    NSString *fullUrl;
    
    //this is a query string
    if([relativeUrl hasPrefix:@"?"]) {
        fullUrl = [self.baseUrl stringByAppendingString:relativeUrl];
    } else {
        hasEnd = [self.baseUrl hasSuffix:@"/"];
        hasStart = [relativeUrl hasPrefix:@"/"];
        if(hasEnd && hasStart) {
            fullUrl = [self.baseUrl stringByAppendingString:[relativeUrl substringFromIndex:1]];
        } else if(!hasEnd && !hasStart) {
            fullUrl = [[self.baseUrl stringByAppendingString:@"/"] stringByAppendingString:relativeUrl];
        } else {
            fullUrl = [self.baseUrl stringByAppendingString:relativeUrl];
        }
    }
    return [[NSURL alloc] initWithString:fullUrl];
}

@end

