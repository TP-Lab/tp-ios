//
//  TPOSWalletManagerCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/8.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSWalletManagerCell.h"
#import "UIColor+Hex.h"
#import "TPOSWalletModel.h"

@interface TPOSWalletManagerCell()

@property (weak, nonatomic) IBOutlet UIButton *backupView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLbael;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenName;
@property (weak, nonatomic) IBOutlet UILabel *tokenValueLabel;


@end

@implementation TPOSWalletManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _backupView.layer.cornerRadius = 2;
    self.tokenValueLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:24];
}

- (void)updateWithModel:(TPOSWalletModel *)walletModel {
    self.walletNameLbael.text = walletModel.walletName;
    self.addressLabel.text = walletModel.address;
    _backupView.hidden = walletModel.isBackup;
}

@end
