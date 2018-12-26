//
//  TPOSExchangeWalletVewController.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSWalletModel;

@interface TPOSExchangeWalletVewController : TPOSBaseViewController

@property (nonatomic, strong) NSArray<TPOSWalletModel *> *walletModels;
@property (nonatomic, weak) TPOSWalletModel *currentWalletModel;

@end
