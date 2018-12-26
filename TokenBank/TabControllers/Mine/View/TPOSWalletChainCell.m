//
//  TPOSWalletChainCell.m
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSWalletChainCell.h"
#import "TPOSBlockChainModel.h"
#import "UIColor+Hex.h"
#import "TPOSLocalizedHelper.h"

@import SDWebImage;

@interface TPOSWalletChainCell()
@property (weak, nonatomic) IBOutlet UIImageView *chainIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chainLabel;

@end

@implementation TPOSWalletChainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithChainModel:(TPOSBlockChainModel *)chainModel {
    [self.chainIcon sd_setImageWithURL:[NSURL URLWithString:chainModel.icon_url]];
    self.titleLabel.text = chainModel.title;
    self.chainLabel.textColor = [UIColor colorWithHex:0x333333];
    self.chainLabel.text = chainModel.desc;
}

@end
