//
//  TPOSContext.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPOSWalletModel;

@interface TPOSContext : NSObject

//当前钱包
@property (nonatomic, strong) TPOSWalletModel *currentWallet;

+ (instancetype)shareInstance;

@end
