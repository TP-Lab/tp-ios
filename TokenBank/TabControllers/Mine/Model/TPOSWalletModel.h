//
//  TPOSWalletModel.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/14.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MJExtension;

@interface TPOSWalletModel : NSObject

@property (nonatomic, copy) NSString *walletId;
@property (nonatomic, copy) NSString *walletName;
@property (nonatomic, copy) NSString *walletIcon;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordTips;
@property (nonatomic, copy) NSString *privateKey;
@property (nonatomic, copy) NSString *blockChainId; //公链id
@property (nonatomic, copy) NSString *mnemonic; //助记词
@property (nonatomic, assign) NSInteger dbVersion; //数据库版本
@property (nonatomic, assign, getter= isBackup) BOOL backup; //是否已备份

@end
