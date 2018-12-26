//
//  TPOSAssetAddTokenCell.m
//  TokenBank
//
//  Created by MarcusWoo on 09/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAssetAddTokenCell.h"
#import "TPOSBlockChainModel.h"
#import "TPOSTokenModel.h"

@import SDWebImage;

@interface TPOSAssetAddTokenCell()
@property (weak, nonatomic) IBOutlet UIImageView *tokenIcon;
@property (weak, nonatomic) IBOutlet UILabel *tokenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chainTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addedButton;
@property (nonatomic, weak) TPOSTokenModel *token;
@property (nonatomic, weak) NSIndexPath *indexPath;
@end

@implementation TPOSAssetAddTokenCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tokenIcon.layer.cornerRadius = 18;
    self.tokenIcon.layer.masksToBounds = YES;
}

- (void)update:(TPOSTokenModel *)model atIndexPath:(NSIndexPath *)idx {
    
    self.token = model;
    self.indexPath = idx;
    
    [self.tokenIcon sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    self.tokenNameLabel.text = model.symbol;
    self.chainTypeLabel.text = model.blockchain.desc;
    self.addedButton.selected = model.added == 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)onAddButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TPOSAssetAddTokenCellDidTapAddButton:indexPath:)]) {
        [self.delegate TPOSAssetAddTokenCellDidTapAddButton:self.token indexPath:self.indexPath];
    }
}

@end
