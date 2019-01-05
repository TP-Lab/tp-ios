//
//  TPOSJTManager.h
//  TokenBank
//
//  Created by MarcusWoo on 25/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPOSJTPOSalance;
@class TPOSJTAmount;
@class TPOSJTPayment;
@class TPOSJTPaymentInfo;
@class TPOSJTPaymentResult;
@class TPOSTokenModel;

@interface TPOSJTManager : NSObject

@property (nonatomic, assign) BOOL finishLoadedTx;
@property (nonatomic, assign) BOOL finishLoadedWallet;

+ (instancetype)shareInstance;

//根据地址查询余额
- (void)checkAccountBalancesWithAddress:(NSString *)address
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure;

//根据发行商查询余额
- (void)checkAccountBalancesWithAddress:(NSString *)address
                                 issuer:(NSString *)issuer
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure;

//根据货币查询余额
- (void)checkAccountBalancesWithAddress:(NSString *)address
                               currency:(NSString *)currency
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure;

//根据发行商、货币查询余额
- (void)checkAccountBalancesWithAddress:(NSString *)address
                               currency:(NSString *)currency
                                 issuer:(NSString *)issuer
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure;

//查询支付选择,如果是swt则不需要查询
- (void)checkPaymentKeyWithSourceAddress:(NSString *)sourceAddress
                      destinationAddress:(NSString *)destinationAddress
                            amountObject:(TPOSJTAmount *)amountObject
                                 success:(void (^)(NSString *key))success
                                 failure:(void (^)(NSError *error))failure;

/**
 *  @brief 发起支付
 **/
- (void)startJTPayment:(TPOSJTPayment *)payment
             secretKey:(NSString *)secretKey
                   fee:(NSString *)fee
               success:(void (^)(TPOSJTPaymentResult *result))success
               failure:(void (^)(NSError *error))failure;

/**
 *  @brief 获得支付信息
 *  @param address 支付用户的井通地址
 *  @param hash    支付交易的hash或资源号
 **/
- (void)requestPaymentInfoWithAddress:(NSString *)address
                              andHash:(NSString *)hash
                              success:(void (^)(TPOSJTPaymentInfo *info))success
                              failure:(void (^)(NSError *error))failure;

/**
 *  @brief 获得支付历史
 *  @param address 支付用户的井通地址
 *  @param seq 上次最后一条的支付hash
 *  @param currency 代币
 *  @param issuer issuer
 **/
- (void)requestPaymentHistoryWithAddress:(NSString *)address
                                   count:(NSInteger)count
                                currency:(NSString *)currency
                                  issuer:(NSString *)issuer
                                     seq:(NSInteger)seq
                                  ledger:(NSInteger)ledger
                                 success:(void (^)(NSArray<TPOSJTPaymentInfo *> *historys,NSInteger ledger,NSInteger seq))success
                                 failure:(void (^)(NSError *error))failure;


- (void)requestBalance:(NSString *)address success:(void(^)(NSArray<TPOSTokenModel *> * tokenList))success
               failure:(void(^)(NSError *error))failure;

@end
