//
//  TPOSTransactionRecoderCell.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSTransactionRecoderModel;

@interface TPOSTransactionRecoderCell : UITableViewCell

- (void)updateWithModel:(TPOSTransactionRecoderModel *)transactionRecoderModel walletAddress:(NSString *)address;

@end
