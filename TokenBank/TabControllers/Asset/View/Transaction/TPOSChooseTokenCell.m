//
//  TPOSChooseTokenCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSMacro.h"
#import "TPOSChooseTokenCell.h"
#import "TPOSTokenModel.h"

@import SDWebImage;


@interface TPOSChooseTokenCell()

@property (weak, nonatomic) IBOutlet UIImageView *tokenImageView;
@property (weak, nonatomic) IBOutlet UILabel *tokenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenAssetLabel;


@end

@implementation TPOSChooseTokenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tokenValueLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:21];
    self.tokenAssetLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:14];
}

- (void)updateWithModel:(TPOSTokenModel *)tokenModel {
    [_tokenImageView sd_setImageWithURL:[NSURL URLWithString:tokenModel.icon_url ?:@""]];
    _tokenNameLabel.text = tokenModel.symbol;
    CGFloat coinAmount = 0;
    if ([tokenModel.blockchain_id isEqualToString:ethChain]) {
        if (tokenModel.balance.length > 0 && tokenModel.decimal != 0) {
            NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:tokenModel.balance];
            NSDecimalNumber *p = [NSDecimalNumber decimalNumberWithMantissa:10 exponent:tokenModel.decimal-1 isNegative:NO];
            NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:4 raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
            NSDecimalNumber *result = [balance decimalNumberByDividingBy:p withBehavior:handler];
            coinAmount = [result floatValue];
        } else {
            coinAmount = 0;
        }
    } else if ([tokenModel.blockchain_id isEqualToString:swtcChain]) {
        coinAmount = [tokenModel.balance doubleValue];
    }
    _tokenValueLabel.text = [NSString stringWithFormat:@"%.4f",coinAmount];
    _tokenAssetLabel.text = [NSString stringWithFormat:@"≈ $ %.2f",tokenModel.asset];
}

@end
