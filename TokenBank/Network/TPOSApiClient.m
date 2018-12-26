//
//  TPOSApiClient.m
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSApiClient.h"
#import <AFNetworking/AFNetworking.h>
#import "TPOSThreadUtils.h"
#import "UIDevice+Utility.h"
#import "TPOSLocalizedHelper.h"
#import "TPOSMacro.h"

@interface TPOSApiClient () {
    AFHTTPSessionManager *_httpSession;
    NSMutableDictionary *_tasks;
}

@end

@implementation TPOSApiClient

+ (instancetype)sharedInstance {
    static TPOSApiClient *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[TPOSApiClient alloc] init];
    });
    
    return sharedObj;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        dispatch_queue_t queue = dispatch_queue_create([[NSString stringWithFormat:@"tb_api.%@", self] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        session.requestSerializer.timeoutInterval = 15.0f;
        session.completionQueue = queue;
        session.operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/x-javascript", @"application/json", @"text/json", @"text/javascript", nil];
        _httpSession = session;
        _tasks = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Public

- (NSString *)postFromService:(NSString *)urlString
                    parameter:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure {
    
    return [self request:urlString method:@"POST" parameters:parameters success:success failure:failure];
}

- (NSString *)requestFromUrl:(NSString *)url
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    
    NSArray *components = [url componentsSeparatedByString:@"?"];
    NSString *urlString = components.firstObject;
    NSMutableDictionary *parameters = @{}.mutableCopy;
    
    if (components && [components count] >= 2) {
        NSString *parameterStr = [components objectAtIndex:1];
        NSArray *parameterArray = [parameterStr componentsSeparatedByString:@"&"];
        
        for (NSString *parameterItem in parameterArray) {
            NSArray *parameterItemArray = [parameterItem componentsSeparatedByString:@"="];
            
            if (parameterItemArray && [parameterItemArray count] == 2) {
                [parameters setObject:[parameterItemArray objectAtIndex:1] forKey:[parameterItemArray objectAtIndex:0]];
            }
        }
    }
    
    return [self request:urlString method:@"GET" parameters:parameters success:success failure:failure];
}

- (NSString *)getFromUrl:(NSString *)url
               parameter:(NSDictionary *)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure {
    return [self request:url method:@"GET" parameters:parameters success:success failure:failure];
}

- (NSString *)request:(NSString *)urlString
               method:(NSString *)method
           parameters:(NSDictionary *)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    
    if (parameters) {
        NSMutableDictionary *params = [parameters mutableCopy];
        if (![params.allKeys containsObject:@"lang"]) {
            [params setObject:[TPOSLocalizedHelper standardHelper].currentLanguage  forKey:@"lang"];
        }
        parameters = [params copy];
    } else {
        parameters = @{@"lang":[TPOSLocalizedHelper standardHelper].currentLanguage};
    }
    
    
    [self settingHeaders:parameters];
    
    NSString *identifier = [[NSUUID UUID] UUIDString];
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    __weak typeof(self) selfWeak = self;
    typedef void (^successBlock)(NSURLSessionDataTask *task, id _Nullable responseObject);
    successBlock s = ^(NSURLSessionDataTask *task, id responseObject) {
        
        __strong typeof(selfWeak) strongSelf = selfWeak;
        if (!strongSelf) { return; }
        
        if ([identifier isKindOfClass:[NSString class]]) {
            NSURLSessionTask *t = [strongSelf->_tasks objectForKey:identifier];
            if (t) {
                @synchronized (self) {
                    [strongSelf->_tasks removeObjectForKey:identifier];
                }
            }
            
            if (!(t && t == task)) {
                return;
            }
        }
        
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];

        TPOSLog(@"[API Client] Http has SUCCEED, URL is (%@) and responseObject count is (%lu), duration (%f)", task.originalRequest.URL, (unsigned long)[responseObject count], end - start);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                if (success) {
                    [TPOSThreadUtils runOnMainThread:^{
                        success(responseObject);
                    }];
                }
            } else {
                TPOSLog(@"[API Client] Internal Server Error, %@", task.response);
                TPOSLog(@"[API Client] Internal Server Error, %@", responseObject);
                
                NSInteger statusCode = [[responseObject objectForKey:@"result"] integerValue];
                NSString *message = [responseObject valueForKey:@"message"];
                
                if (message == nil) {
                    message = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"unknown_error"];
                }
                
                if (failure) {
                    NSDictionary *data = [strongSelf isSafeDict:[responseObject objectForKey:@"data"]];
                    
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: message ? : @"",
                                               @"data": data ? : @{}
                                               };
                    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:statusCode userInfo:userInfo];
                    [TPOSThreadUtils runOnMainThread:^{
                        failure(formattedError);
                    }];
                }
            }
        } else {
            TPOSLog(@"[API Client] Internal Server Error, %@", task.response);
            TPOSLog(@"[API Client] Internal Server Error: %@", responseObject);
            
            NSInteger statusCode = [[responseObject objectForKey:@"result"] integerValue];

            if (failure) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: [[TPOSLocalizedHelper standardHelper] stringWithKey:@"unknown_data_type"]
                                           };
                NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:1 userInfo:userInfo];
                [TPOSThreadUtils runOnMainThread:^{
                    failure(formattedError);
                }];
            }
        }
    };
    
    typedef void (^failBlock)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error);
    failBlock f = ^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        
        if ([identifier isKindOfClass:[NSString class]]) {
            __strong typeof(selfWeak) strongSelf = selfWeak;
            if (!strongSelf) { return; }
            NSURLSessionTask *t = [strongSelf->_tasks objectForKey:identifier];
            if (t) {
                @synchronized (self) {
                    [strongSelf->_tasks removeObjectForKey:identifier];
                }
            } else {
                return;
            }
        }
        
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        TPOSLog(@"[API Client] Net Error: (%@), duration (%f)", error, end - start);
        TPOSLog(@"[API Client] Net Error: %@", task.currentRequest);
        
        if (failure) {
            [TPOSThreadUtils runOnMainThread:^{
                failure(error);
            }];
        }
    };
    
    NSURLSessionTask *task;
    if ([@"POST" isEqual:[method uppercaseString]]) {
        task = [_httpSession POST:urlString parameters:parameters progress:nil success:s failure:f];
    } else if ([@"GET" isEqual:[method uppercaseString]]) {
        task = [_httpSession GET:urlString parameters:parameters progress:nil success:s failure:f];
    } else if ([@"DELETE" isEqual:[method uppercaseString]]) {
        task = [_httpSession DELETE:urlString parameters:parameters success:s failure:f];
    }
    
    if (task && [identifier isKindOfClass:[NSString class]]) {
        @synchronized (self) {
            _tasks[identifier] = task;
        }
    }
    
    return task ? identifier : nil;
}

- (NSString *)jsonPost:(NSString *)urlString
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    session.requestSerializer.timeoutInterval = 15.0f;
    session.operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/x-javascript", @"application/json", @"text/json", @"text/javascript", nil];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    
    NSString *identifier = [[NSUUID UUID] UUIDString];
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
    __weak typeof(self) selfWeak = self;
    typedef void (^successBlock)(NSURLSessionDataTask *task, id _Nullable responseObject);
    successBlock s = ^(NSURLSessionDataTask *task, id responseObject) {
        
        __strong typeof(selfWeak) strongSelf = selfWeak;
        if (!strongSelf) { return; }
        
        if ([identifier isKindOfClass:[NSString class]]) {
            NSURLSessionTask *t = [strongSelf->_tasks objectForKey:identifier];
            if (t) {
                @synchronized (self) {
                    [strongSelf->_tasks removeObjectForKey:identifier];
                }
            }
            
            if (!(t && t == task)) {
                return;
            }
        }
        
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        
        TPOSLog(@"[API Client] Http has SUCCEED, URL is (%@) and responseObject count is (%lu), duration (%f)", task.originalRequest.URL, (unsigned long)[responseObject count], end - start);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                if (success) {
                    [TPOSThreadUtils runOnMainThread:^{
                        success(responseObject);
                    }];
                }
            } else {
                TPOSLog(@"[API Client] Internal Server Error, %@", task.response);
                TPOSLog(@"[API Client] Internal Server Error, %@", responseObject);
                
                NSInteger statusCode = [[responseObject objectForKey:@"result"] integerValue];
                NSString *message = [responseObject valueForKey:@"message"];
                
                if (message == nil) {
                    message = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"unknown_error"];
                }
                
                if (failure) {
                    NSDictionary *data = [strongSelf isSafeDict:[responseObject objectForKey:@"data"]];
                    
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: message ? : @"",
                                               @"data": data ? : @{}
                                               };
                    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:statusCode userInfo:userInfo];
                    [TPOSThreadUtils runOnMainThread:^{
                        failure(formattedError);
                    }];
                }
            }
        } else {
            TPOSLog(@"[API Client] Internal Server Error, %@", task.response);
            TPOSLog(@"[API Client] Internal Server Error: %@", responseObject);
            
            NSInteger statusCode = [[responseObject objectForKey:@"result"] integerValue];
            
            if (failure) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: [[TPOSLocalizedHelper standardHelper] stringWithKey:@"unknown_data_type"]
                                           };
                NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:1 userInfo:userInfo];
                [TPOSThreadUtils runOnMainThread:^{
                    failure(formattedError);
                }];
            }
        }
    };
    
    typedef void (^failBlock)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error);
    failBlock f = ^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        
        if ([identifier isKindOfClass:[NSString class]]) {
            __strong typeof(selfWeak) strongSelf = selfWeak;
            if (!strongSelf) { return; }
            NSURLSessionTask *t = [strongSelf->_tasks objectForKey:identifier];
            if (t) {
                @synchronized (self) {
                    [strongSelf->_tasks removeObjectForKey:identifier];
                }
            } else {
                return;
            }
        }
        
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        TPOSLog(@"[API Client] Net Error: (%@), duration (%f)", error, end - start);
        TPOSLog(@"[API Client] Net Error: %@", task.currentRequest);
        
        if (failure) {
            [TPOSThreadUtils runOnMainThread:^{
                failure(error);
            }];
        }
    };
    
    NSURLSessionTask *task;
    task = [session POST:urlString parameters:parameters progress:nil success:s failure:f];
    
    if (task && [identifier isKindOfClass:[NSString class]]) {
        @synchronized (self) {
            _tasks[identifier] = task;
        }
    }
    
    return task ? identifier : nil;
}


- (BOOL)cancelWithIdentifier:(NSString *)identifier {
    if (![identifier isKindOfClass:[NSString class]]) return NO;
    
    @synchronized (self) {
        NSURLSessionTask *task = [_tasks objectForKey:identifier];
        if (task) {
            [task cancel];
            [_tasks removeObjectForKey:identifier];
            return YES;
        }
        return NO;
    }
}

- (void)cancelAll {
    @synchronized (self) {
        [_tasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSURLSessionTask * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj cancel];
        }];
        [_tasks removeAllObjects];
    }
}

#pragma mark - Private
- (void)settingHeaders:(NSDictionary *)parameters {
    //动态数据
    NSString *deviceSystemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceModel = [[UIDevice currentDevice] tb_deviceModel];
    NSString *appVersion = [[UIDevice currentDevice] tb_appVersion];
    NSString *appBundleVersion = [[UIDevice currentDevice] tb_appBundleVersion];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    //设置cookies
    NSString *cookie = [NSString stringWithFormat:@"os=%@; osver=%@; model=%@; appver=%@; appcode=%@; time=%@;", @"ios", deviceSystemVersion, deviceModel, appVersion, appBundleVersion, time];
    [_httpSession.requestSerializer
     setValue:cookie
     forHTTPHeaderField:@"Cookie"];
}

- (NSDictionary *)isSafeDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return dict;
    } else if ([dict isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return nil;
    }
}

@end
