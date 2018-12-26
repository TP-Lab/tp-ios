//
//  TPOSWeb3Handler.m
//  WebJS
//
//  Created by MarcusWoo on 12/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSWeb3Handler.h"
#import "WebViewJavascriptBridge.h"
#import "TPOSMacro.h"

@interface TPOSWeb3Handler()<WKNavigationDelegate,WKUIDelegate>
@property WebViewJavascriptBridge *bridge;
@property WebViewJavascriptBridge *mnemonicBridge;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebView *mnemonicWebView;

@property (nonatomic, copy) void(^finishLoadCallback)(void);
@property (nonatomic, copy) void(^mnemonicFinishLoadCallback)(void);

@end

@implementation TPOSWeb3Handler

+ (instancetype)sharedManager {
    static TPOSWeb3Handler *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - Account
- (void)initWeb3WithProvider:(NSString *)provider callback:(TPOSWeb3HandlerCallback)callback{
    [_bridge callHandler:@"eth_init" data:provider responseCallback:^(id responseData) {
        TPOSLog(@"initWeb3WithProvider response:%@",responseData);
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)createAccountWithEntropy:(NSString *)entropy callback:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_createAccount" data:entropy responseCallback:^(id responseData) {
        TPOSLog(@"createAccountWithEntropy responseData: %@",responseData);
        if (callback) {
            callback(responseData);
        }
    }];
}
//web3.utils.isAddress(
- (void)isValidAddress:(NSString *)address callback:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"isAddress" data:address responseCallback:^(id responseData) {
        TPOSLog(@"createAccountWithEntropy responseData: %@",responseData);
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)retrieveAccoutWithPrivateKey:(NSString *)privateKey callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_privateKeyToAccount" data:privateKey responseCallback:^(id responseData) {
        TPOSLog(@"retrieveAccoutWithPrivateKey responseData: %@", responseData);
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)accountSignTransactionWithData:(NSDictionary *)data callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"accountSignTransaction" data:[self dataTojsonString:data] responseCallback:^(id responseData) {
        TPOSLog(@"accountSignTransaction responseData: %@", responseData);
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)createMnemonicWalletWithDerivePath:(NSString *)derivePath callback:(TPOSWeb3HandlerCallback)callback {
    NSString *dPath = derivePath;
    if (!dPath || dPath.length == 0) {
        dPath = @"m/44'/60'/0'/0/0";
    }
    [_mnemonicBridge callHandler:@"eth_createMnemonicWallet" data:dPath responseCallback:^(id responseData) {
        TPOSLog(@"accountSignTransaction responseData: %@", responseData);
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)retrieveWalletFromMnemonic:(NSString *)mnemonic
                     andDerivePath:(NSString *)derivePath
                          callback:(TPOSWeb3HandlerCallback)callback {
    if (!mnemonic) {
        callback(nil);
        return;
    }
    if (!derivePath || derivePath.length == 0) {
        derivePath = @"m/44'/60'/0'/0/0";
    }
    
    NSDictionary *data = @{@"mnemonic":mnemonic,@"derivePath":derivePath};
    
    [_mnemonicBridge callHandler:@"eth_retrieveWalletFromMnemonic"
                            data:[self dataTojsonString:data]
                responseCallback:^(id responseData) {
                    if (callback) {
                        callback(responseData);
                    }
                }];
}

#pragma mark - Wallet
- (void)createWalletWithCount:(NSInteger)count entropy:(NSString *)entropy callBack:(TPOSWeb3HandlerCallback)callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (count) {
        [params setObject:[NSString stringWithFormat:@"%ld",count>0?count:1] forKey:@"numberOfAccounts"];
    }
    if (entropy && entropy.length > 0) {
        [params setObject:entropy forKey:@"entropy"];
    }
    [_bridge callHandler:@"eth_createWallet" data:[self dataTojsonString:params] responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)addAccountToWalletWithPrivateKey:(NSString *)privateKey callBack:(TPOSWeb3HandlerCallback)callback {
    if (privateKey && privateKey.length > 0) {
        [_bridge callHandler:@"eth_addAccountToWallet" data:privateKey responseCallback:^(id responseData) {
            if (callback) {
                callback(responseData);
            }
        }];
    } else {
        callback(nil);
    }
}

- (void)removeAccountFromWalletWithPrivateKey:(NSString *)privateKey callBack:(TPOSWeb3HandlerCallback)callback {
    if (privateKey && privateKey.length > 0) {
        [_bridge callHandler:@"eth_removeAccountFromWallet" data:privateKey responseCallback:^(id responseData) {
            if (callback) {
                callback(responseData);
            }
        }];
    } else {
        callback(nil);
    }
}

- (void)clearWallet {
    [_bridge callHandler:@"eth_clearWallet"];
}

- (void)encryptWalletWithPassword:(NSString *)password callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_encryptWallet" data:password responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)removeAccountFromWalletWithAddress:(NSString *)address callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_removeAccount" data:address responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)decryptWalletWithArray:(NSArray *)array password:(NSString *)password callBack:(TPOSWeb3HandlerCallback)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (array && array.count > 0) {
        [dict setObject:array forKey:@"keystoreArray"];
    }
    if (password) {
        [dict setObject:password forKey:@"password"];
    }
    [_bridge callHandler:@"decryptWallet" data:[self dataTojsonString:dict] responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

#pragma mark - iban

- (void)changeToAddressWithIban:(NSString *)iban callBack:(TPOSWeb3HandlerCallback)callback {
    if (iban && iban.length > 0) {
        [_bridge callHandler:@"eth_toAddress" data:iban responseCallback:^(id responseData) {
            if (callback) {
                callback(responseData);
            }
        }];
    }
}

- (void)changeToIbanWithAddress:(NSString *)address callBack:(TPOSWeb3HandlerCallback)callback {
    if (address && address.length > 0) {
        [_bridge callHandler:@"eth_toIban" data:address responseCallback:^(id responseData) {
            if (callback) {
                callback(responseData);
            }
        }];
    }
}

- (void)changeToIbanWithEtherAddress:(NSString *)address callBack:(TPOSWeb3HandlerCallback)callback {
    if (address && address.length > 0) {
        [_bridge callHandler:@"eth_fromEthereumAddress" data:address responseCallback:^(id responseData) {
            if (callback) {
                callback(responseData);
            }
        }];
    }
}

#pragma mark - Transaction
- (void)changeToWeiOfUnitType:(NSString *)unitType withCount:(CGFloat)count callBack:(TPOSWeb3HandlerCallback)callback {
    NSString *type = unitType;
    if (!type || type.length == 0) {
        type = @"ether";
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:type forKey:@"tokenType"];
    [dict setObject:[NSString stringWithFormat:@"%f",count] forKey:@"count"];
    [_bridge callHandler:@"eth_changeToWei" data:[self dataTojsonString:dict] responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)weiChangeToTokenOfTokenType:(NSString *)tokenType withCount:(NSString *)count callBack:(TPOSWeb3HandlerCallback)callback {
    NSString *type = tokenType;
    if (!type || type.length == 0) {
        type = @"ether";
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:type forKey:@"tokenType"];
    [dict setObject:[NSString stringWithFormat:@"%@",count] forKey:@"count"];
    [_bridge callHandler:@"eth_weiChangeToEth" data:[self dataTojsonString:dict] responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)sendSignedTransactionWithData:(NSDictionary *)data callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_sendTransaction" data:[self dataTojsonString:data] responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)getGasPriceWithCallBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_getGasPrice" data:nil responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)getEstimateGasWithData:(NSDictionary *)data callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_estimateGas" data:[self dataTojsonString:data] responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)toHex:(NSString *)data callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_toHex" data:data responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

- (void)hexToString:(NSString *)data callBack:(TPOSWeb3HandlerCallback)callback {
    [_bridge callHandler:@"eth_toBN" data:data responseCallback:^(id responseData) {
        if (callback) {
            callback(responseData);
        }
    }];
}

+ (NSString *)tokenValueFromInput:(NSString *)input {
    if (![TPOSWeb3Handler isTransaction:input]) {
        return @"0";
    }
    
    NSString *tokenValue = [input substringFromIndex:74];
    return [NSString stringWithFormat:@"0x%@", tokenValue];
}

+ (BOOL)isTransaction:(NSString *)input {
    if (input.length <= 74) {
        return NO;
    }
    
    NSString *address = [[input substringToIndex:10] uppercaseString];
    if (![@"0xa9059cbb" isEqualToString:[address lowercaseString]]) { //验证是不是交易
        return NO;
    }
    return YES;
}

#pragma mark - Private

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

- (WKWebView *)pureWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    
    return [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
}

- (void)initWebEnviromentWithFinishCallback:(void (^)(void))callback mnemonicCallback:(void (^)(void))mCallback{
    if (_bridge) { return; }
    
    self.finishLoadCallback = callback;
    self.mnemonicFinishLoadCallback = mCallback;
    
    self.webView = [self pureWebView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    self.mnemonicWebView = [self pureWebView];
    self.mnemonicWebView.navigationDelegate = self;
    self.mnemonicWebView.UIDelegate = self;
    
//#ifdef DEBUG
    [WebViewJavascriptBridge enableLogging];
//#endif
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    _mnemonicBridge = [WebViewJavascriptBridge bridgeForWebView:self.mnemonicWebView];
    [_mnemonicBridge setWebViewDelegate:self];
    
    [self loadWeb3Page:self.webView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.webView];
    
    [self loadMnemonicPage:self.mnemonicWebView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.mnemonicWebView];
}

- (void)loadWeb3Page:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"web3" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)loadMnemonicPage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"mnemonic" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    TPOSLog(@"finish loaded");
    if ([webView isEqual:self.webView]) {
        if (self.finishLoadCallback) {
            self.finishLoadCallback();
        }
    } else if ([webView isEqual:self.mnemonicWebView]) {
        if (self.mnemonicFinishLoadCallback) {
            self.mnemonicFinishLoadCallback();
        }
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    TPOSLog(@"alert message:%@", message);
    completionHandler();
}

@end

