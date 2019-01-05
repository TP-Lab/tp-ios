//
//  TPOSJTManager.m
//  TokenBank
//
//  Created by MarcusWoo on 25/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSJTManager.h"
#import "TPOSApiClient.h"
#import "TPOSJTPOSalance.h"
#import "TPOSJTPayment.h"
#import "TPOSJTPaymentInfo.h"
#import "TPOSJTPaymentResult.h"
#import "NSObject+TPOS.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"
#import "TPOSTokenModel.h"
#import <jcc_oc_base_lib/JTWalletManager.h>
#import <jcc_oc_base_lib/JccChains.h>

#define kJTApiPrefix @"https://api.jingtum.com"

#define jingchangExchangeApiPrefix @"https://ewdjbbl8jgf.jccdex.cn"

@interface TPOSJTManager()
@end

@implementation TPOSJTManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TPOSJTManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[TPOSJTManager alloc] init];
    });
    return manager;
}

- (NSString *)jtUrlWithPath:(NSString *)path {
    NSString *url = [NSString stringWithFormat:@"%@%@",kJTApiPrefix,path];
    return url;
}

- (NSString *)jingchangUrlWithPath:(NSString *)path {
    NSString *url = [NSString stringWithFormat:@"%@%@",jingchangExchangeApiPrefix,path];
    return url;
}

//根据地址查询余额
//sequence用于本地签名
- (void)checkAccountBalancesWithAddress:(NSString *)address
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure {
    
    [self checkAccountBalancesWithAddress:address
                                 currency:nil
                                   issuer:nil
                                  success:success
                                  failure:failure];
}

//根据发行商查询余额
//sequence用于本地签名
- (void)checkAccountBalancesWithAddress:(NSString *)address
                                 issuer:(NSString *)issuer
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure {
    
    [self checkAccountBalancesWithAddress:address
                                 currency:nil
                                   issuer:issuer
                                  success:success
                                  failure:failure];
}

//根据货币查询余额
//sequence用于本地签名
- (void)checkAccountBalancesWithAddress:(NSString *)address
                               currency:(NSString *)currency
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure {
    
    [self checkAccountBalancesWithAddress:address
                                 currency:currency
                                   issuer:nil
                                  success:success
                                  failure:failure];
}

//sequence用于本地签名
- (void)checkAccountBalancesWithAddress:(NSString *)address
                               currency:(NSString *)currency
                                 issuer:(NSString *)issuer
                                success:(void(^)(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence))success
                                failure:(void(^)(NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"/v2/accounts/%@/balances",address];
    NSString *url = [self jtUrlWithPath:path];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (currency && currency.length > 0) {
        [params setObject:currency forKey:@"currency"];
    }
    if (issuer && issuer.length > 0) {
        [params setObject:issuer forKey:@"issuer"];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[TPOSApiClient sharedInstance] getFromUrl:url parameter:params success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"status_code"] integerValue] == 0) {
                NSArray *bls = [responseObject objectForKey:@"balances"];
                NSArray *blObjs = [TPOSJTPOSalance mj_objectArrayWithKeyValuesArray:bls];
                NSInteger seq = [[responseObject objectForKey:@"sequence"] integerValue];
                if (success) {
                    success(blObjs, seq);
                }
            } else {
                if (failure) {
                    failure([weakSelf errorDomain:url reason:@"status_code != 0"]);
                }
            }
        }else {
            if (failure) {
                failure([weakSelf errorDomain:url reason:@"responseObject is not Dictionary"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)checkPaymentKeyWithSourceAddress:(NSString *)sourceAddress
                      destinationAddress:(NSString *)destinationAddress
                            amountObject:(TPOSJTAmount *)amountObject
                                 success:(void (^)(NSString *key))success
                                 failure:(void (^)(NSError *error))failure {
    
    NSString *amountParam = [NSString stringWithFormat:@"%@+%@+%@",amountObject.value,amountObject.currency,amountObject.issuer];
    NSString *path = [NSString stringWithFormat:@"/v2/accounts/%@/payments/choices/%@/%@",sourceAddress,destinationAddress,amountParam];
    NSString *url = [self jtUrlWithPath:path];
    
    __weak typeof(self) weakSelf = self;
    
    [[TPOSApiClient sharedInstance] getFromUrl:url parameter:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"status_code"] integerValue] == 0) {
                NSArray *choices = [responseObject objectForKey:@"choices"];
                NSString *key = nil;
                for (NSDictionary *choice in choices) {
                    if ([choice isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *cDict = [choice objectForKey:@"choice"];
                        NSString *currency = [cDict objectForKey:@"currency"];
                        if (currency && [currency isEqualToString:amountObject.currency]) {
                            key = [choice objectForKey:@"key"];
                            break;
                        }
                    }
                }
                if (key && key.length > 0) {
                    if (success) {
                        success(key);
                    }
                }
            } else {
                if (failure) {
                    failure([weakSelf errorDomain:url reason:@"status_code != 0"]);
                }
            }
        } else {
            if (failure) {
                failure([weakSelf errorDomain:url reason:@"responseObject is not Dictionary"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)startJTPayment:(TPOSJTPayment *)payment
             secretKey:(NSString *)secretKey
                   fee:(NSString *)fee
               success:(void (^)(TPOSJTPaymentResult *result))success
               failure:(void (^)(NSError *error))failure {
    
    if (!payment || !payment.amount) {
        if (failure) {
            failure([self errorDomain:@"/v2/blob" reason:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"missing_param"]]);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self checkAccountBalancesWithAddress:payment.source currency:payment.amount.currency success:^(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence) {
        
        NSMutableDictionary *parms = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (fee && fee.length > 0) {
            [parms setObject:fee forKey:@"Fee"];
        } else {
            [parms setObject:@"0.1" forKey:@"Fee"];
        }
        [parms setObject:@(sequence) forKey:@"Sequence"];
        NSMutableDictionary *amount = [[NSMutableDictionary alloc] initWithCapacity:0];
        [amount setObject:payment.amount.value forKey:@"value"];
        [amount setObject:payment.amount.currency forKey:@"currency"];
        [amount setObject:payment.amount.issuer forKey:@"issuer"];
        [parms setObject:payment.source forKey:@"Account"];
        [parms setObject:amount forKey:@"Amount"];
        [parms setObject:payment.destination forKey:@"Destination"];
        [parms setValue:@"Payment" forKey:@"TransactionType"];
        [parms setValue:[[NSNumber alloc] initWithInt:0] forKey:@"Flags"];
        [[JTWalletManager shareInstance] sign:parms secret:secretKey chain:SWTC_CHAIN completion:^(NSError *error, NSString *signature) {
            if (!error) {
                NSString *url = [self jingchangUrlWithPath:@"/exchange/sign_payment"];
                [[TPOSApiClient sharedInstance] jsonPost:url parameters:@{@"sign":signature} success:^(id responseObject) {
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"code"] isEqualToString:jingchangSuccessCode]) {
                        TPOSJTPaymentResult *result = [[TPOSJTPaymentResult alloc] init];
                        NSString *msg = [responseObject objectForKey:@"msg"];
                        NSDictionary *txDict = [responseObject objectForKey:@"data"];
                        NSString *txHash = [txDict objectForKey:@"hash"];
                        result.success = YES;
                        result.resultMsg = msg;
                        result.py_hash = txHash;
                        if (success) {
                            success(result);
                        }
                    } else {
                        if (failure) {
                            failure([weakSelf errorDomain:@"/exchange/sign_payment" reason:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_fail"]]);
                        }
                    }
                } failure:^(NSError *error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            } else {
                if (failure) {
                    failure([weakSelf errorDomain:@"/exchange/sign_payment" reason:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"sign_failed"]]);
                }
            }
        }];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestPaymentInfoWithAddress:(NSString *)address
                              andHash:(NSString *)hash
                              success:(void (^)(TPOSJTPaymentInfo *info))success
                              failure:(void (^)(NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"/v2/accounts/%@/payments/%@",address,hash];
    NSString *url = [self jtUrlWithPath:path];
    
    __weak typeof(self) weakSelf = self;
    
    [[TPOSApiClient sharedInstance] getFromUrl:url parameter:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"status_code"] integerValue] == 0) {
                TPOSJTPaymentInfo *info = [TPOSJTPaymentInfo mj_objectWithKeyValues:responseObject];
                if (success) {
                    success(info);
                }
            } else {
                if (failure) {
                    failure([weakSelf errorDomain:url reason:@"status_code != 0"]);
                }
            }
        } else {
            if (failure) {
                failure([weakSelf errorDomain:url reason:@"responseObject is not Dictionary"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestPaymentHistoryWithAddress:(NSString *)address
                                   count:(NSInteger)count
                                currency:(NSString *)currency
                                  issuer:(NSString *)issuer
                                     seq:(NSInteger)seq
                                  ledger:(NSInteger)ledger
                                 success:(void (^)(NSArray<TPOSJTPaymentInfo *> *historys,NSInteger ledger,NSInteger seq))success
                                 failure:(void (^)(NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"/v2/accounts/%@/payments",address];
    NSString *url = [self jtUrlWithPath:path];
    
    NSMutableDictionary *parameter = @{@"results_per_page":@(count > 0 ? count : 10),
                                }.mutableCopy;
    /*
     currency    String    指定返回对应货币的余额
     issuer    String    指定返回对应银关发行的货币
     */
    
    if (currency.length > 0) {
        [parameter setObject:currency forKey:@"currency"];
    }
    
    if (issuer.length > 0) {
        [parameter setObject:currency forKey:@"issuer"];
    }
    
    if (seq > 0) {
        NSData *dara = [NSJSONSerialization dataWithJSONObject:@{@"ledger":@(ledger),@"seq":@(seq)} options:0 error:NULL];
        [parameter setObject:[[NSString alloc] initWithData:dara encoding:NSUTF8StringEncoding] forKey:@"marker"];
    }
    __weak typeof(self) weakSelf = self;
    
    [[TPOSApiClient sharedInstance] getFromUrl:url parameter:parameter success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"status_code"] integerValue] == 0) {
                NSArray *historyList = [TPOSJTPaymentInfo mj_objectArrayWithKeyValuesArray:[responseObject[@"payments"] tb_nullToNilIfNeed]];
                if (success) {
                    NSDictionary *marker = [responseObject[@"marker"] tb_nullToNilIfNeed];
                    success(historyList,[[marker objectForKey:@"ledger"] integerValue],[marker[@"seq"] integerValue]);
                }
            } else {
                if (failure) {
                    failure([weakSelf errorDomain:url reason:@"status_code != 0"]);
                }
            }
        } else {
            if (failure) {
                failure([weakSelf errorDomain:url reason:@"responseObject is not Dictionary"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void) requestBalance:(NSString *)address success:(void (^)(NSArray<TPOSTokenModel *> *))success failure:(void (^)(NSError *))failure {
    NSString *path = [NSString stringWithFormat:@"/exchange/balances/%@",address];
    NSString *url = [self jingchangUrlWithPath:path];
    
    __weak typeof(self) weakSelf = self;
    
    [[TPOSApiClient sharedInstance] requestFromUrl:url success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] isEqualToString:jingchangSuccessCode]) {
                if (success) {
                    NSMutableArray *arr = [NSMutableArray new];
                    NSArray *datas = [responseObject objectForKey:@"data"];
                    for (NSDictionary *data in datas) {
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            TPOSTokenModel *model = [TPOSTokenModel new];
                            NSString *currency = [data objectForKey:@"currency"];
                            NSString *value = [data objectForKey:@"value"];
                            model.address = address;
                            model.balance = value;
                            model.blockchain_id = swtcChain;
                            model.create_time = nil;
                            model.symbol = currency;
                            model.decimal = 0;
                            model.hid = [swtcChain integerValue];
                            model.bl_symbol = currency;
                            model.token_type = [currency isEqualToString:@"SWT"] ? 0 : 1;
                            model.icon_url = @"http://state.jingtum.com/favicon.ico";
                            [arr addObject:model];
                        }
                    }
                    if (success) {
                        success(arr);
                    }
                }
            } else {
                if (failure) {
                    failure([weakSelf errorDomain:url reason:@"code != 0"]);
                }
            }
        } else {
            if (failure) {
                failure([weakSelf errorDomain:url reason:@"responseObject is not Dictionary"]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSError *)errorDomain:(NSString *)domain reason:(NSString *)reason {
    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{NSLocalizedDescriptionKey:reason}];
    return error;
}

@end
