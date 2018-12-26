//
//  TPOSJTManager.m
//  TokenBank
//
//  Created by MarcusWoo on 25/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSJTManager.h"
#import "TPOSApiClient.h"
#import "TPOSJTWallet.h"
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

#define kJTApiPrefix @"https://api.jingtum.com"

#define jingchangExchangeApiPrefix @"https://ewdjbbl8jgf.jccdex.cn"

@interface TPOSJTManager()<WKNavigationDelegate,WKUIDelegate>
@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *webView;

@property WebViewJavascriptBridge* walletBridge;
@property (nonatomic, strong) WKWebView *walletWebView;
@end

@implementation TPOSJTManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TPOSJTManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[TPOSJTManager alloc] init];
        [manager initJTWebEnviroment];
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

//本地创建钱包
- (void)createJingTumWallet:(void(^)(TPOSJTWallet *wallet, NSError *error))completion {
    
    __weak typeof(self) weakSelf = self;
    
    [_walletBridge callHandler:@"jt_createWallet" data:nil responseCallback:^(id responseData) {
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            TPOSJTWallet *wallet = [TPOSJTWallet mj_objectWithKeyValues:responseData];
            if (completion) {
                completion(wallet,nil);
            }
        } else {
            if (completion) {
                completion(nil, [weakSelf errorDomain:@"local bundle.js" reason:@"responseData is not Dictionary"]);
            }
        }
    }];
}

//根据pk获得钱包
- (void)retrieveWalletWithPk:(NSString *)pk completion:(void(^)(TPOSJTWallet *wallet, NSError *error))completion {
    
    __weak typeof(self) weakSelf = self;

    [_walletBridge callHandler:@"jt_createWalletFromPk" data:pk responseCallback:^(id responseData) {
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            TPOSJTWallet *wallet = [TPOSJTWallet mj_objectWithKeyValues:responseData];
            if (completion) {
                completion(wallet,nil);
            }
        } else {
            if (completion) {
                completion(nil, [weakSelf errorDomain:@"local bundle.js" reason:@"responseData is not Dictionary"]);
            }
        }
    }];
}

//校验钱包地址是否有效
- (void)isValidAddress:(NSString *)address completion:(void(^)(BOOL isValid, NSError *error))completion {
    __weak typeof(self) weakSelf = self;
    
    [_walletBridge callHandler:@"jt_isAddress" data:address responseCallback:^(id responseData) {
        if ([responseData isKindOfClass:[NSNumber class]]) {
            if (completion) {
                completion([responseData boolValue],nil);
            }
        } else {
            if (completion) {
                completion(nil, [weakSelf errorDomain:@"local bundle.js" reason:@"responseData is not Dictionary"]);
            }
        }
    }];
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
    __weak typeof(_bridge) weakBridge = _bridge;
    
    [self checkAccountBalancesWithAddress:payment.source currency:payment.amount.currency success:^(NSArray<TPOSJTPOSalance *> *balances, NSInteger sequence) {
        
        NSMutableDictionary *parms = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (fee && fee.length > 0) {
            [parms setObject:fee forKey:@"fee"];
        } else {
            [parms setObject:@"0.1" forKey:@"fee"];
        }
        [parms setObject:@(sequence) forKey:@"sequence"];
        [parms setObject:payment.source forKey:@"account"];
        [parms setObject:payment.amount.value forKey:@"value"];
        [parms setObject:payment.amount.currency forKey:@"currency"];
        [parms setObject:payment.amount.issuer forKey:@"issuer"];
        [parms setObject:payment.destination forKey:@"destination"];
        [parms setObject:secretKey forKey:@"seed"];
        
        NSString *json = [weakSelf dataTojsonString:parms];
        
        [weakBridge callHandler:@"jt_sign" data:json responseCallback:^(id responseData) {
            if (responseData) {
                NSString *url = [self jingchangUrlWithPath:@"/exchange/sign_payment"];
                [[TPOSApiClient sharedInstance] jsonPost:url parameters:@{@"sign":responseData} success:^(id responseObject) {
                    
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

#pragma mark - WebView

- (WKWebView *)pureWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    return [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
}

- (void)initJTWebEnviroment {
    if (_bridge) { return; }
    
    self.webView = [self pureWebView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    self.walletWebView = [self pureWebView];
    self.walletWebView.navigationDelegate = self;
    self.walletWebView.UIDelegate = self;
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    _walletBridge = [WebViewJavascriptBridge bridgeForWebView:self.walletWebView];
    [_walletBridge setWebViewDelegate:self];
    
    [self loadJTWebPage:self.webView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.webView];
    
    [self loadWalletWebPage:self.walletWebView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.walletWebView];
}

- (void)loadJTWebPage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"jtWeb3" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)loadWalletWebPage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"jtWallet" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    TPOSLog(@"finish loaded");
    if ([webView isEqual:self.webView]) {
        self.finishLoadedTx = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTFinishLoadedTxNotification object:nil];
    } else {
        self.finishLoadedWallet = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTFinishLoadedWalletNotification object:nil];
    }
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    TPOSLog(@"%@", message);
    completionHandler();
}

- (NSString *)dataTojsonString:(id)object {
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        TPOSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
