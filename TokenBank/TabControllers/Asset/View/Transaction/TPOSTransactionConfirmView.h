//
//  TPOSTransactionConfirmView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"

@class TPOSTransactionConfirmView;

@protocol TPOSTransactionConfirmViewDelegate<NSObject>
- (void)TPOSTransactionConfirmView:(TPOSTransactionConfirmView *)confirmView didConfirmPassword:(NSString *)pswd;
@end

@interface TPOSTransactionConfirmView : TPOSAlertView

@property (nonatomic, weak) id<TPOSTransactionConfirmViewDelegate> delegate;

+ (TPOSTransactionConfirmView *)transactionConfirmView;

- (void)changeLanguage;

- (void)fillFromLabel:(NSString *)from;
- (void)fillToLabel:(NSString *)to;
- (void)fillMinerfee:(NSString *)minerfee;
- (void)fillGasDescLabel:(NSString *)gasDesc;
- (void)fillMoneyLabel:(NSString *)money;

@end
