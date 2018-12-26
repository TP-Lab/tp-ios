//
//  TPOSTransactionDetailViewController.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/21.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSTransactionRecoderModel;
@class TPOSJTPaymentInfo;

@interface TPOSTransactionDetailViewController : TPOSBaseViewController

@property (nonatomic, copy) NSString *blockChainId;
@property (nonatomic, copy) NSString *currentAddress;
@property (nonatomic, weak) TPOSTransactionRecoderModel *transactionRecoderModel;
@property (nonatomic, weak) TPOSJTPaymentInfo *payInfo;

@end
