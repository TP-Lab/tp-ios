//
//  TPOSAssetCreateWalletView.h
//  TokenBank
//
//  Created by MarcusWoo on 10/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"

@class TPOSTokenModel;

@protocol TPOSAssetCreateWalletViewDelegate<NSObject>
- (void)TPOSAssetCreateWalletViewDidTapInjectWithToken:(TPOSTokenModel *)token;//导入钱包
- (void)TPOSAssetCreateWalletViewDidTapCreateWithToken:(TPOSTokenModel *)token;//创建钱包
@end

@interface TPOSAssetCreateWalletView : TPOSAlertView
@property (nonatomic, weak) id<TPOSAssetCreateWalletViewDelegate> delegate;

+ (instancetype)walletViewWithToken:(TPOSTokenModel *)token;

- (void)changeLanguage;

@end
