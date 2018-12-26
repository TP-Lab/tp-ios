//
//  TPOSAssetTopView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAssetTopView.h"
#import "TPOSMacro.h"
#import "UIColor+Hex.h"
#import "UIImage+TPOS.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSAssetTopView()

@property (weak, nonatomic) IBOutlet UIView *changeWalletView;
@property (weak, nonatomic) IBOutlet UIButton *transactionButton;
@property (weak, nonatomic) IBOutlet UIButton *receiverButton;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;

@end

@implementation TPOSAssetTopView

+ (TPOSAssetTopView *)assetTopView {
    TPOSAssetTopView *view = [[NSBundle mainBundle] loadNibNamed:@"TPOSAssetTopView" owner:nil options:nil].firstObject;
    if (kIphoneX) {
        view.frame = CGRectMake(0, 0, kScreenWidth, 88);
    } else {
        view.frame = CGRectMake(0, 0, kScreenWidth, 64);
    }
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.indicatorImageView.image = [[UIImage imageNamed:@"icon_main_indicator"] tb_imageWithTintColor:[UIColor whiteColor]];
    [self inWalletMode:YES];
    [self inOpenChangeWallet:NO];
    [self changeLanguage];
}

- (void)changeLanguage {
    [self.receiverButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"receive"] forState:UIControlStateNormal];
    [self.transactionButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"transaction"]  forState:UIControlStateNormal];
}

- (void)inWalletMode:(BOOL)isIn {
    if ((isIn && !self.changeWalletView.hidden) || (!isIn && self.changeWalletView.hidden)) {
        return;
    }
    self.changeWalletView.hidden = !isIn;
    self.transactionButton.hidden = isIn;
    self.receiverButton.hidden = isIn;
}

- (void)inOpenChangeWallet:(BOOL)isIn {
    [UIView animateWithDuration:0.3 animations:^{
        if (isIn) {
            _indicatorImageView.transform = CGAffineTransformIdentity;
        } else {
            _indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }];   
}

- (void)updateCurrentWalletName:(NSString *)name {
    self.walletNameLabel.text = name;
}

- (IBAction)changeWalletAction {
    if ([_delegate respondsToSelector:@selector(assetTopViewDidTapChangeWalletButton:)]) {
        [_delegate assetTopViewDidTapChangeWalletButton:self];
    }
}

- (IBAction)transactionAction {
    if ([_delegate respondsToSelector:@selector(assetTopViewDidTapTransactionButton:)]) {
        [_delegate assetTopViewDidTapTransactionButton:self];
    }
}

- (IBAction)receiverAction {
    if ([_delegate respondsToSelector:@selector(assetTopViewDidTapReceiverButton:)]) {
        [_delegate assetTopViewDidTapReceiverButton:self];
    }
}

- (IBAction)addAction {
    if ([_delegate respondsToSelector:@selector(assetTopViewDidTapAddButton:)]) {
        [_delegate assetTopViewDidTapAddButton:self];
    }
}

@end
