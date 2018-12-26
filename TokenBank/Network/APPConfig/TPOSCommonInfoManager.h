//
//  TPOSCommonInfoManager.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/31.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPOSBlockChainModel;
@class TPOSRecommendGasModel;

@interface TPOSCommonInfoManager : NSObject

+ (instancetype)shareInstance;

//获取所有链信息
- (void)getAllBlockChainInfoWithSuccess:(void (^)(NSArray<TPOSBlockChainModel *> *blockChains))success fail:(void (^)(NSError *error))fail;

//获取所有公链并且存在单例，方便下次使用
//以下两方法配合使用
- (void)storeAllBlockchainInfos;
- (void)storeAllBlockchainInfos:(NSArray<TPOSBlockChainModel *> *)blockChains;
- (NSArray<TPOSBlockChainModel *> *)allBlockchains;

@end
