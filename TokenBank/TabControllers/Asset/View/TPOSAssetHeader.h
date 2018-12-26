//
//  TPOSAssetHeader.h
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPOSAssetHeaderDelegate<NSObject>
- (void)TPOSAssetHeaderDidTapTransactionButton;
- (void)TPOSAssetHeaderDidTapReceiverButton;
- (void)TPOSAssetHeaderDidTapPrivateButtonWithStatus:(BOOL)status;
@end

@interface TPOSAssetHeader : UIView

@property (nonatomic, weak) id<TPOSAssetHeaderDelegate> delegate;

- (void)changeLanguage;
- (void)updateTotalAsset:(CGFloat)totalAsset unit:(NSString *)unit privateMode:(BOOL)privateModel;

@end
