//
//  TPOSAssetEmptyView.m
//  TokenBank
//
//  Created by MarcusWoo on 12/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAssetEmptyView.h"
#import "UIImage+TPOS.h"
#import "UIColor+Hex.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSAssetEmptyView()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *addAssetButton;
@end

@implementation TPOSAssetEmptyView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addAssetButton setBackgroundImage:[UIImage tb_imageWithColor:[UIColor colorWithHex:0x2890FE] andSize:CGSizeMake(135, 47)] forState:UIControlStateNormal];
    self.addAssetButton.layer.cornerRadius = 3;
    self.addAssetButton.layer.masksToBounds = YES;
    
    [self changeLanguage];
}

- (void)changeLanguage {
    self.descLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"support_token_tip"];
}

+ (instancetype)emptyViewWithDelegate:(id<TPOSAssetEmptyViewDelegate>)delegateObj {
    TPOSAssetEmptyView *emptyView = (TPOSAssetEmptyView *)[[NSBundle mainBundle] loadNibNamed:@"TPOSAssetEmptyView" owner:nil options:nil].firstObject;
    emptyView.delegate = delegateObj;
    return emptyView;
}

- (IBAction)onAddAssetButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TPOSAssetEmptyViewDidTapAddAssetButton)]) {
        [self.delegate TPOSAssetEmptyViewDidTapAddAssetButton];
    }
}

@end
