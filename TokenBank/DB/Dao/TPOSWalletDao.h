//
//  TPOSWalletDao.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPOSBaseDao.h"

@class TPOSWalletModel;

@interface TPOSWalletDao : TPOSBaseDao

//新增钱包
- (void)addWalletWithWalletModel:(TPOSWalletModel *)walletModel complement:(void (^)(BOOL success))complement;

//修改钱包
- (void)updateWalletWithWalletModel:(TPOSWalletModel *)walletModel complement:(void (^)(BOOL success))complement;

//删除钱包
- (void)deleteWalletWithAddress:(NSString *)address complement:(void (^)(BOOL success))complement;

//获取所有钱包
-(void)findAllWithComplement:(void (^)(NSArray<TPOSWalletModel *> *walletModels))complement;

//根据钱包ID找
- (void)findWalletWithWalletId:(NSString *)walletId complement:(void (^)(TPOSWalletModel *walletModel))complement;

//获取当前钱包id
- (void)findCurrentWallet:(void (^)(TPOSWalletModel *walletModel))complement;

//更新当前钱包id
- (void)updateCurrentWalletID:(NSString *)walletId complement: (void(^)(BOOL success)) complement;

@end
