//
//  TPOSWalletDetailDaoManager.h
//  TokenBank
//
//  Created by MarcusWoo on 21/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TPOSTokenModel;

@interface TPOSWalletDetailDaoManager : NSObject

+ (instancetype)shareInstance;

//添加、更新，均调该方法
- (void)updateWalletDetailModels:(NSArray<TPOSTokenModel *> *)detailModels;
//删除
- (void)deleteWalletDetailModels:(NSArray<TPOSTokenModel *> *)detailModels;
//查找
- (void)findWalletDetailWithAddress:(NSString *)address
                          completion:(void (^)(NSArray<TPOSTokenModel *> *detailModels))completion;

- (void)findAllWithCompletion:(void (^)(NSArray<TPOSTokenModel *> *detailModels))completion;

@end
