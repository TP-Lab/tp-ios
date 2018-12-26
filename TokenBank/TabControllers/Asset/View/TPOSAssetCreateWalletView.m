//
//  TPOSAssetCreateWalletView.m
//  TokenBank
//
//  Created by MarcusWoo on 10/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAssetCreateWalletView.h"
#import "TPOSTokenModel.h"
#import "TPOSBlockChainModel.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSAssetCreateWalletView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *injectButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) TPOSTokenModel *token;

@end

@implementation TPOSAssetCreateWalletView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.injectButton.layer.cornerRadius = 4;
    self.injectButton.layer.borderWidth = 1;
    self.injectButton.layer.borderColor = [UIColor colorWithHex:0x2890FE].CGColor;
    self.injectButton.layer.masksToBounds = YES;
    
    self.createButton.layer.cornerRadius = 4;
    self.createButton.layer.masksToBounds = YES;
    
    [self changeLanguage];
}

- (void)changeLanguage {
    [self.injectButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_wallet"] forState:UIControlStateNormal];
    [self.createButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_wallet"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"cancel"] forState:UIControlStateNormal];
}

+ (instancetype)walletViewWithToken:(TPOSTokenModel *)token {
    TPOSAssetCreateWalletView *view = (TPOSAssetCreateWalletView *)[[NSBundle mainBundle] loadNibNamed:@"TPOSAssetCreateWalletView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, kScreenWidth, 271);
    view.token = token;
    [view refreshUIData];
    return view;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if (self.safeAreaInsets.bottom > 0) {
        CGRect f = self.frame;
        f.origin.y -= self.safeAreaInsets.bottom;
        f.size.height += self.safeAreaInsets.bottom;
        self.frame = f;
    }
}

- (void)refreshUIData {
    NSString *chain = self.token.blockchain.desc;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"has_no"],chain,[[TPOSLocalizedHelper standardHelper] stringWithKey:@"title_wallet"]];
    self.descLabel.text = [NSString stringWithFormat:@"%@%@%@，%@%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"has_no"],chain,[[TPOSLocalizedHelper standardHelper] stringWithKey:@"s_wallet"],chain,[[TPOSLocalizedHelper standardHelper] stringWithKey:@"s_only_token_chain"]];
}

- (IBAction)onCancelButtonTapped:(id)sender {
    [self hide];
}

- (IBAction)onInjectButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(TPOSAssetCreateWalletViewDidTapInjectWithToken:)]) {
        [self.delegate TPOSAssetCreateWalletViewDidTapInjectWithToken:self.token];
    }
    [self hide];
}

- (IBAction)onCreateButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(TPOSAssetCreateWalletViewDidTapCreateWithToken:)]) {
        [self.delegate TPOSAssetCreateWalletViewDidTapCreateWithToken:self.token];
    }
    [self hide];
}

@end
