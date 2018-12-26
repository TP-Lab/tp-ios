//
//  TPOSAssetHeader.m
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAssetHeader.h"
#import "TPOSWalletModel.h"
#import "TPOSMacro.h"
#import "TPOSContext.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSAssetHeader()

@property (weak, nonatomic) IBOutlet UILabel *assetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *transactionButton;
@property (weak, nonatomic) IBOutlet UIButton *receiverButton;
@property (weak, nonatomic) IBOutlet UIButton *walletButton;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;

@property (nonatomic, assign) CGFloat totalAsset;
@property (nonatomic, strong) NSString *unit;

@end

@implementation TPOSAssetHeader

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTotalAsset:(CGFloat)totalAsset unit:(NSString *)unit privateMode:(BOOL)privateModel {
    if (!privateModel) {
        self.assetsLabel.text = [NSString stringWithFormat:@"%.2f",totalAsset];
        self.unitLabel.text = [NSString stringWithFormat:@"%@", [[TPOSLocalizedHelper standardHelper] stringWithKey:@"my_asset"]];
    }
    self.unit = unit;
    _totalAsset = totalAsset;
}

- (void)updatePrivateStatus:(BOOL)status {
    if (status) {
        self.assetsLabel.text = @"✻✻✻✻✻";
        self.assetsLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:24];
    } else {
        self.assetsLabel.text = [NSString stringWithFormat:@"%.2f",_totalAsset];
        self.assetsLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:34];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.assetsLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:34];
    if (kIphoneX) {
        self.topConstraint.constant += 24;
    }
    
    [self changeLanguage];
}

- (void)changeLanguage {
    [self.transactionButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"transaction"] forState:UIControlStateNormal];
    [self.receiverButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"receive"] forState:UIControlStateNormal];
    self.unitLabel.text = [NSString stringWithFormat:@"%@", [[TPOSLocalizedHelper standardHelper] stringWithKey:@"my_asset"]];
}

- (IBAction)onTransactionButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TPOSAssetHeaderDidTapTransactionButton)]) {
        [self.delegate TPOSAssetHeaderDidTapTransactionButton];
    }
}

- (IBAction)onReceiverButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TPOSAssetHeaderDidTapReceiverButton)]) {
        [self.delegate TPOSAssetHeaderDidTapReceiverButton];
    }
}

- (IBAction)privateAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self updatePrivateStatus:sender.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(TPOSAssetHeaderDidTapPrivateButtonWithStatus:)]) {
        [self.delegate TPOSAssetHeaderDidTapPrivateButtonWithStatus:sender.isSelected];
    }
}


@end
