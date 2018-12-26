//
//  TPOSAssetChooseWalletView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/31.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSWalletModel;

@interface TPOSAssetChooseWalletView : UIView

+ (TPOSAssetChooseWalletView *)showInView:(UIView *)view walletModels:(NSArray<TPOSWalletModel *> *)walletModels offset:(CGFloat)offset selectWalletModel:(TPOSWalletModel *)walletModel callBack:(void(^)(TPOSWalletModel *walletModel,BOOL add,BOOL cancel))callBack;

- (void)close;

@end
