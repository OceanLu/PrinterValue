//
//  APIClient.m
//  EWalking
//
//  Created by ZhangChuntao on 7/11/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "APIClient.h"
#import "constant.h"
#import "DataModel.h"
#import "AppDelegate.h"

@implementation APIClient

- (NSDictionary *)constructParameters:(NSDictionary *)params
{
    NSMutableDictionary* newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSNumber *clientId = [NSNumber numberWithLongLong: SharedAppDelegate.user.clientId];
    [newParams setObject:clientId forKey:@"clientid"];
    return newParams;
}

- (AFHTTPRequestOperation *)requestPath:(NSString *)path
                             parameters:(NSDictionary *)params
                                success:(void (^)(AFHTTPRequestOperation *operation, id JSON))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *newParams = [self constructParameters:params];

    return [super GET:path parameters:newParams success:success failure:failure];
}

- (AFHTTPRequestOperation *)requestPath:(NSString *)path
                             parameters:(NSDictionary *)params
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *newParams = [self constructParameters:params];
    
    return [super POST:path parameters:newParams constructingBodyWithBlock:block success:success failure:failure];
}

static NSString * const APIBaseURLString = SERVER_URL;

+ (instancetype)sharedClient
{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

@end
