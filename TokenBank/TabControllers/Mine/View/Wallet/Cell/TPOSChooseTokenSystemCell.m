//
//  TPOSChooseTokenSystemCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSChooseTokenSystemCell.h"
#import "TPOSBlockChainModel.h"
#import "TPOSLocalizedHelper.h"

@import SDWebImage;

@interface TPOSChooseTokenSystemCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tokenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *createAbleButton;

@end

@implementation TPOSChooseTokenSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateWithModel:(TPOSBlockChainModel *)blockChainModel {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",blockChainModel.icon_url ?: @""]]];
    _tokenNameLabel.text = blockChainModel.default_token;
    _systemTypeLabel.text = [NSString stringWithFormat:@"%@",blockChainModel.title];
}

- (BOOL)canCreateAble {
    return !self.createAbleButton.isSelected;
}

@end
