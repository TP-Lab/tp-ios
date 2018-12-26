//
//  TPOSTransactionRecoderCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionRecoderCell.h"
#import "TPOSTransactionRecoderModel.h"
#import "TPOSContext.h"
#import "TPOSWalletModel.h"
#import "TPOSWeb3Handler.h"
#import "TPOSTokenModel.h"
#import "NSDate+TPOS.h"
#import "NSString+TPOS.h"
#import "TPOSJTPaymentInfo.h"
#import "TPOSLocalizedHelper.h"
#import "TPOSMacro.h"

@interface TPOSTransactionRecoderCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@end

@implementation TPOSTransactionRecoderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateWithModel:(TPOSTransactionRecoderModel *)transactionRecoderModel walletAddress:(NSString *)address {
    
    if ([transactionRecoderModel isKindOfClass:[TPOSTransactionRecoderModel class]]) {
        self.dateLabel.text = [NSDate dateDescriptionFrom:transactionRecoderModel.timestamp];
        
        BOOL isOut = NO;
        
        if ([[transactionRecoderModel.from uppercaseString] isEqualToString:[address uppercaseString]]) {
            self.addressLabel.text = transactionRecoderModel.to;
            self.typeImageView.image = [UIImage imageNamed:@"icon_transaction_out"];
            isOut = YES;
        } else {
            self.addressLabel.text = transactionRecoderModel.from;//transactionRecoderModel.token_value
            self.typeImageView.image = [UIImage imageNamed:@"icon_transaction_in"];
            isOut = NO;
        }
        
        NSString *value;
        NSString *symbol = @"ETH";
        if ([transactionRecoderModel.type isEqualToString:nonnativeToken]) { //代币
            value = transactionRecoderModel.token_value;
            symbol = transactionRecoderModel.symbol.length>0?transactionRecoderModel.symbol:@"Unknown";
            if (value && transactionRecoderModel.decimal) {
                NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:value];
                NSInteger dec = transactionRecoderModel.decimal.longLongValue;
                NSDecimalNumber *p = [NSDecimalNumber decimalNumberWithMantissa:10 exponent:(dec>0?dec:18)- 1 isNegative:NO];
                NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:4 raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
                NSDecimalNumber *result = [balance decimalNumberByDividingBy:p withBehavior:handler];
                value = [result stringValue];
            } else {
                value = @"0";
            }
            self.moneyLabel.text = [NSString stringWithFormat:@"%@%@ %@", isOut?@"-":@"+" ,value, symbol];
        } else {
            value = transactionRecoderModel.value;
            __weak typeof(self) weakSelf = self;
            [[TPOSWeb3Handler sharedManager] weiChangeToTokenOfTokenType:nil withCount:value callBack:^(id responseObject) {
                weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%@%@ %@", isOut?@"-":@"+" ,responseObject, symbol];
            }];
        }
        
        if ([transactionRecoderModel.status isEqualToString:transactionSuccess]) {
            self.waitLabel.hidden = YES;
        } else if ([transactionRecoderModel.status isEqualToString:transactionFail]) {
            self.waitLabel.hidden = NO;
            self.waitLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_fai"];
        } else {
            self.waitLabel.hidden = NO;
            self.waitLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"packaging"];
        }
    } else if ([transactionRecoderModel isKindOfClass:[TPOSJTPaymentInfo class]]) {
        TPOSJTPaymentInfo *payInfo = (TPOSJTPaymentInfo *)transactionRecoderModel;
        self.addressLabel.text = payInfo.counterparty;
        if ([payInfo.type isEqualToString:@"sent"]) {
            self.typeImageView.image = [UIImage imageNamed:@"icon_transaction_out"];
            self.moneyLabel.text = [NSString stringWithFormat:@"-%@ %@", payInfo.amount.value, payInfo.amount.currency];
        } else {
            self.typeImageView.image = [UIImage imageNamed:@"icon_transaction_in"];
            self.moneyLabel.text = [NSString stringWithFormat:@"+%@ %@", payInfo.amount.value, payInfo.amount.currency];
        }
        self.dateLabel.text = [NSDate dateDescriptionFrom:[payInfo.date longLongValue]];
        self.waitLabel.hidden = YES;
    }
}

@end
