//
//  TPOSAssetCell.m
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSMacro.h"
#import "TPOSAssetCell.h"
#import "TPOSTokenModel.h"

@import SDWebImage;

@interface TPOSAssetCell()
@property (weak, nonatomic) IBOutlet UIImageView *tokenIcon;
@property (weak, nonatomic) IBOutlet UILabel *tokenName;
@property (weak, nonatomic) IBOutlet UILabel *tokenAmount;
@property (weak, nonatomic) IBOutlet UILabel *tokenValue;

@property (nonatomic, strong) TPOSTokenModel *tokenModel;

@end

@implementation TPOSAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateWithModel:(TPOSTokenModel *)tokenModel {
    _tokenModel = tokenModel;
    self.tokenName.text = tokenModel.symbol;
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
    self.tokenAmount.font = [UIFont fontWithName:@"DINAlternate-Bold" size:21];
    self.tokenValue.font = [UIFont fontWithName:@"DINAlternate-Bold" size:14];
    self.tokenAmount.text = [NSString stringWithFormat:@"%.4f",coinAmount];
    [self.tokenIcon sd_setImageWithURL:[NSURL URLWithString:tokenModel.icon_url]];
//    self.tokenValue.text = [NSString stringWithFormat:@"≈ $ %.2f",tokenModel.asset];
}

- (void)updatePrivateStatus:(BOOL)status {
    if (status) {
        self.tokenAmount.text = @"✻✻✻✻✻";
//        self.tokenValue.text = @"✻ ✻ ✻ ✻";
        self.tokenAmount.font = [UIFont fontWithName:@"DINAlternate-Bold" size:15];
//        self.tokenValue.font = [UIFont fontWithName:@"DINAlternate-Bold" size:10];
    }
}

@end
