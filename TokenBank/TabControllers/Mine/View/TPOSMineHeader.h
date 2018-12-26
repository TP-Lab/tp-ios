//
//  TPOSMineHeader.h
//  TokenBank
//
//  Created by MarcusWoo on 06/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPOSMineHeaderDelegate<NSObject>
- (void)TPOSMineHeaderDelegateDidTapWalletButton;
- (void)TPOSMineHeaderDelegateDidTapTransButton;
@end

@interface TPOSMineHeader : UIView

@property (nonatomic, weak) id<TPOSMineHeaderDelegate> delegate;

- (void)changeLanguage;

@end
