//
//  TPOSMessageCenterCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSMessageCenterCell.h"
#import "TPOSMacro.h"
#import "TPOSTransactionRecoderModel.h"
#import "NSDate+TPOS.h"
#import "TPOSContext.h"
#import "TPOSWalletModel.h"
#import "TPOSWeb3Handler.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSMessageCenterCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end

@implementation TPOSMessageCenterCell


- (void)updateWithModle:(TPOSTransactionRecoderModel *)transactionRecoderModel {
    
    NSString *value;
    NSString *symbol = @"ETH";
    if ([transactionRecoderModel.type isEqualToString:nonnativeToken]) { //代币
        value = transactionRecoderModel.token_value;
        symbol = transactionRecoderModel.symbol;
    } else {
        value = transactionRecoderModel.value;
    }
    
    __weak typeof(self) weakSelf = self;
    if ([transactionRecoderModel.from isEqualToString:[TPOSContext shareInstance].currentWallet.address]) {
        _subTitleLabel.text = [NSString stringWithFormat:@"%@：%@", [[TPOSLocalizedHelper standardHelper] stringWithKey:@"receiver"], transactionRecoderModel.to];
        [[TPOSWeb3Handler sharedManager] weiChangeToTokenOfTokenType:nil withCount:value callBack:^(id responseObject) {
            weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@：%@ %@ %@", [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_noti"],responseObject, symbol, [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_suc"]];
        }];
        
    } else {
        _subTitleLabel.text = [NSString stringWithFormat:@"%@：%@", [[TPOSLocalizedHelper standardHelper] stringWithKey:@"sender"],transactionRecoderModel.from];
        [[TPOSWeb3Handler sharedManager] weiChangeToTokenOfTokenType:nil withCount:value callBack:^(id responseObject) {
            weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@：%@ %@ %@", [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_noti"],responseObject, symbol, [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_suc"]];
        }];
    }
    
    _timeLabel.text = [NSDate dateDescriptionFrom:transactionRecoderModel.timestamp];
    //timeLabel
}



@end
