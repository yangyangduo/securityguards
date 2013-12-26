//
//  RestClient.h
//  topsales
//
//  Created by young on 4/10/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestResponse.h"
#import "XXStringUtils.h"

typedef NS_ENUM(NSInteger, AuthenticationType) {
    AuthenticationTypeNone,
    AuthenticationTypeBasic
};


@interface RestClient : NSObject {
    
}

@property(strong, nonatomic) NSString *authName;
@property(strong, nonatomic) NSString *authPassword;
@property(strong, nonatomic) NSString *baseUrl;
@property(nonatomic) AuthenticationType auth;
@property(nonatomic) NSInteger timeoutInterval;

#pragma mark -
#pragma mark Initializations

- (id)initWithBaseUrl:(NSString *)u;
- (id)initWithBaseUrl:(NSString *) u authName:n authPassword:p authType:(AuthenticationType)a;

#pragma mark -
#pragma mark Classic Style

- (void)getForUrl:(NSString *) u acceptType:(NSString *) a success:(SEL) s error:(SEL) e for:(NSObject *) obj callback:(id)cb;

- (void)postForUrl:(NSString *)u acceptType:(NSString *)a contentType:c body:(NSData *) b success:(SEL) s error:(SEL) e for:(NSObject *) obj callback:(id)cb;

- (void)putForUrl:(NSString *) u acceptType:(NSString *) a contentType:(NSString *) c body:(NSData *) b success:(SEL) s error:(SEL)e for:(NSObject *) obj callback:(id)cb;

- (void)deleteForUrl:(NSString *) u success:(SEL) s error:(SEL) e for:(NSObject *) obj callback:(id)cb;

- (void)executeForUrl:(NSString *) u method:(NSString *) m headers:(NSDictionary *) h body:(NSData *)b success:(SEL) s error:(SEL) e for : (NSObject *) obj callback:(id)cb;

#pragma mark -
#pragma mark Block Style

- (void)get:(NSString *)url acceptType:(NSString *)acceptType success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error ;

- (void)post:(NSString *)url acceptType:(NSString *)acceptType contentType:(NSString *)contentType body:(NSData *)body success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error;

- (void)put:(NSString *)url acceptType:(NSString *)acceptType contentType:(NSString *)contentType body:(NSData *)body success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error;

- (void)delete:(NSString *)url success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))error;

- (void)execute:(NSString *)u method:(NSString *)m headers:(NSDictionary *)h body:(NSData *)b success:(void(^)(RestResponse *resp))success error:(void(^)(RestResponse *resp))err;

- (NSURL *)getFullUrl:(NSString *)relativeUrl;

@end
