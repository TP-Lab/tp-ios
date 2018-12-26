//
//  TPOSApiClient.h
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOSApiClient : NSObject

+ (instancetype)sharedInstance;

- (NSString *)request:(NSString *)urlString
               method:(NSString *)method
           parameters:(NSDictionary *)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

- (NSString *)postFromService:(NSString *)urlString
                    parameter:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

- (NSString *)requestFromUrl:(NSString *)url
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

- (NSString *)getFromUrl:(NSString *)url
               parameter:(NSDictionary *)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

- (NSString *)jsonPost:(NSString *)urlString
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

- (BOOL)cancelWithIdentifier:(NSString *)identifier;
- (void)cancelAll;

@end
