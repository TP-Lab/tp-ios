//
//  TPOSWalletDetailDao.h
//  TokenBank
//
//  Created by MarcusWoo on 21/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPOSBaseDao.h"

@class TPOSTokenModel;

@interface TPOSWalletDetailDao : TPOSBaseDao

//添加
- (void)addWalletDetailWithModel:(TPOSTokenModel *)detailModel
                      completion:(void (^)(BOOL success))completion;

- (void)addWalletDetailInDB:(FMDatabase *)db
                  withModel:(TPOSTokenModel *)detailModel
                 completion:(void (^)(BOOL success))completion;

//更新
- (void)updateWalletDetailWithModel:(TPOSTokenModel *)detailModel
                         completion:(void (^)(BOOL success))completion;

- (void)updateWalletDetailInDB:(FMDatabase *)db
                     withModel:(TPOSTokenModel *)detailModel
                    completion:(void (^)(BOOL success))completion;

//删除
- (void)deleteWalletWithAddress:(NSString *)address
                     completion:(void (^)(BOOL success))completion;

//清空表数据
- (void)removeAllWithCompletion:(void (^)(BOOL success, FMDatabase * db))completion;

//查找
- (void)findWalletDetailWithAddress:(NSString *)address
                          completion:(void (^)(NSArray<TPOSTokenModel *> *detailModels, FMDatabase * db))completion;

- (void)findAllWithCompletion:(void (^)(NSArray<TPOSTokenModel *> *detailModels))completion;

@end
