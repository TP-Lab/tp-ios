//
//  TPOSAssetTopView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSAssetTopView;

@protocol TPOSAssetTopViewDelegate <NSObject>

- (void)assetTopViewDidTapAddButton:(TPOSAssetTopView *)assetTopView;
- (void)assetTopViewDidTapChangeWalletButton:(TPOSAssetTopView *)assetTopView;
- (void)assetTopViewDidTapTransactionButton:(TPOSAssetTopView *)assetTopView;
- (void)assetTopViewDidTapReceiverButton:(TPOSAssetTopView *)assetTopView;

@end

@interface TPOSAssetTopView : UIView

@property (nonatomic, weak) id<TPOSAssetTopViewDelegate> delegate;

+ (TPOSAssetTopView *)assetTopView;

- (void)changeLanguage;
- (void)inWalletMode:(BOOL)isIn;
- (void)inOpenChangeWallet:(BOOL)isIn;
- (void)updateCurrentWalletName:(NSString *)name;

@end
