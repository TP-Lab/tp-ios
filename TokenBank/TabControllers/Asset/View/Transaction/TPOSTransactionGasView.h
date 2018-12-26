//
//  TPOSTransactionGasView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/3.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"

@interface TPOSTransactionGasView : TPOSAlertView

@property (nonatomic, copy) void (^ethChooseGasPrice)(long long gasLimite,long long gasPrice);

@property (nonatomic, copy) void (^jtChooseGasPrice)(CGFloat gas);

//eth
+ (TPOSTransactionGasView *)transactionGasViewWithGasLimite:(long long)gasLimite defaultPrice:(long long)defaultPrice;

//JT
+ (TPOSTransactionGasView *)transactionViewWithMinFee:(CGFloat)min maxFee:(CGFloat)max recommentFee:(CGFloat)recomment;

@end
