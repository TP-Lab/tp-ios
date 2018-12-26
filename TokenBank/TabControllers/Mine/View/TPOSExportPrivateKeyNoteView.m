//
//  TPOSExportPrivateKeyNoteView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSExportPrivateKeyNoteView.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSWalletModel.h"
#import "NSString+TPOS.h"
#import "TPOSLocalizedHelper.h"

@import Toast;

@interface TPOSExportPrivateKeyNoteView()

@property (weak, nonatomic) IBOutlet UIView *warningView;

@property (weak, nonatomic) IBOutlet UIView *keyView;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UIButton *copyyButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic, strong) TPOSWalletModel *walletModel;

@end

@implementation TPOSExportPrivateKeyNoteView

+ (TPOSExportPrivateKeyNoteView *)exportPrivateKeyNoteViewWithWalletModel:(TPOSWalletModel *)walletModel {
    TPOSExportPrivateKeyNoteView *exportPrivateKeyNoteView = [[NSBundle mainBundle] loadNibNamed:@"TPOSExportPrivateKeyNoteView" owner:nil options:nil].firstObject;
    exportPrivateKeyNoteView.walletModel = walletModel;
    
    return exportPrivateKeyNoteView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.warningView.layer.borderWidth = 1;
    self.warningView.layer.borderColor = [UIColor colorWithHex:0xD81400].CGColor;
    self.warningView.layer.cornerRadius = 5;
    self.keyView.layer.cornerRadius = 5;
    self.copyyButton.layer.cornerRadius = 5;
    self.layer.cornerRadius = 5;
    
    CGSize size = [_tipsLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat heightAddtion = (size.height-17);
    self.frame = CGRectMake(0, 0, kScreenWidth - 40, CGRectGetHeight(self.frame) + heightAddtion);
}

- (IBAction)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",_keyLabel.text]];
    [self.window makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_to_board"]];
    _copyyButton.userInteractionEnabled = NO;
    [_copyyButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copied"] forState:UIControlStateNormal];
    _copyyButton.backgroundColor = [[UIColor colorWithHex:0x289FE0] colorWithAlphaComponent:0.5];
}

- (IBAction)closeAction {
    [super hide];
}

- (void)setWalletModel:(TPOSWalletModel *)walletModel {
    _walletModel = walletModel;
    _keyLabel.text = [walletModel.privateKey tb_encodeStringWithKey:walletModel.password];
    CGSize size = [_keyLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat heightAddtion = (size.height-33.5);
    self.frame = CGRectMake(0, 0, kScreenWidth - 40, CGRectGetHeight(self.frame) + heightAddtion);
}

@end
