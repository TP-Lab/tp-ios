//
//  TPOSWeb3Handler.h
//  WebJS
//
//  Created by MarcusWoo on 12/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TPOSWeb3HandlerCallback) (id responseObject);

@interface TPOSWeb3Handler : NSObject

+ (instancetype)sharedManager;

- (void)initWebEnviromentWithFinishCallback:(void(^)(void))callback mnemonicCallback:(void(^)(void))mCallback;

//account
- (void)initWeb3WithProvider:(NSString *)provider callback:(TPOSWeb3HandlerCallback)callback;

- (void)createAccountWithEntropy:(NSString *)entropy callback:(TPOSWeb3HandlerCallback)callback;

- (void)retrieveAccoutWithPrivateKey:(NSString *)privateKey callBack:(TPOSWeb3HandlerCallback)callback;

//校验地址
- (void)isValidAddress:(NSString *)address callback:(TPOSWeb3HandlerCallback)callback;

//生成钱包，同时返回助记词
- (void)createMnemonicWalletWithDerivePath:(NSString *)derivePath callback:(TPOSWeb3HandlerCallback)callback;

//根据助记词，取回钱包
- (void)retrieveWalletFromMnemonic:(NSString *)mnemonic andDerivePath:(NSString *)derivePath callback:(TPOSWeb3HandlerCallback)callback;

//交易签名
/*!
 {transactionToSign:transactionToSign,privateKey:privateKey}
 
 transactionToSign
 nonce - String: (optional) The nonce to use when signing this transaction. Default will use web3.eth.getTransactionCount().
 chainId - String: (optional) The chain id to use when signing this transaction. Default will use web3.eth.net.getId().
 to - String: (optional) The recevier of the transaction, can be empty when deploying a contract.
 data - String: (optional) The call data of the transaction, can be empty for simple value transfers.
 value - String: (optional) The value of the transaction in wei.
 gas - String: The gas provided by the transaction.
 gasPrice - String: (optional) The gas price set by this transaction, if empty, it will use web3.eth.gasPrice()
 */
- (void)accountSignTransactionWithData:(NSDictionary *)data callBack:(TPOSWeb3HandlerCallback)callback;

//wallet
- (void)createWalletWithCount:(NSInteger)count entropy:(NSString *)entropy callBack:(TPOSWeb3HandlerCallback)callback;

- (void)addAccountToWalletWithPrivateKey:(NSString *)privateKey callBack:(TPOSWeb3HandlerCallback)callback;

- (void)removeAccountFromWalletWithPrivateKey:(NSString *)privateKey callBack:(TPOSWeb3HandlerCallback)callback;

- (void)clearWallet;

- (void)encryptWalletWithPassword:(NSString *)password callBack:(TPOSWeb3HandlerCallback)callback;

- (void)decryptWalletWithArray:(NSArray *)array password:(NSString *)password callBack:(TPOSWeb3HandlerCallback)callback;

//每删除一个钱包也需要执行一次
- (void)removeAccountFromWalletWithAddress:(NSString *)address callBack:(TPOSWeb3HandlerCallback)callback;

//iban
- (void)changeToAddressWithIban:(NSString *)iban callBack:(TPOSWeb3HandlerCallback)callback;

- (void)changeToIbanWithAddress:(NSString *)address callBack:(TPOSWeb3HandlerCallback)callback;
- (void)changeToIbanWithEtherAddress:(NSString *)address callBack:(TPOSWeb3HandlerCallback)callback;

//transaction
- (void)changeToWeiOfUnitType:(NSString *)unitType withCount:(CGFloat)count callBack:(TPOSWeb3HandlerCallback)callback;

- (void)weiChangeToTokenOfTokenType:(NSString *)tokenType withCount:(NSString *)count callBack:(TPOSWeb3HandlerCallback)callback;

- (void)sendSignedTransactionWithData:(NSDictionary *)data callBack:(TPOSWeb3HandlerCallback)callback;

- (void)getGasPriceWithCallBack:(TPOSWeb3HandlerCallback)callback;

- (void)getEstimateGasWithData:(NSDictionary *)data callBack:(TPOSWeb3HandlerCallback)callback;

//字符串转16进制
- (void)toHex:(NSString *)data callBack:(TPOSWeb3HandlerCallback)callback;

//16进制转字符串
- (void)hexToString:(NSString *)data callBack:(TPOSWeb3HandlerCallback)callback;

//代币input解析出tokenvalue
/*! demo
 NSString *a = @"MethodID: 0xa9059cbb"
 "[0]:0000000000000000000000000d07301143cc8bea1ed470f574f6f8815c1ca2b8"
 "[1]:0000000000000000000000000000000000000000000000056bc75e2d63100000";
 NSString *v = [TPOSWeb3Handler tokenValueFromInput:a];
 
 [[TPOSWeb3Handler sharedManager] weiChangeToTokenOfTokenType:nil withCount:v callBack:^(id responseObject) {
 TPOSLog(@"----v:%@", responseObject);
 }];

 */
+ (NSString *)tokenValueFromInput:(NSString *)input;
//input是不是交易信息
+ (BOOL)isTransaction:(NSString *)input;
@end

