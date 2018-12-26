//
//  TPOSTransactionGasView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/3.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionGasView.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"
#import "TPOSWeb3Handler.h"

@interface TPOSTransactionGasView()

@property (weak, nonatomic) IBOutlet UITextField *gasValieLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasUnitLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UISlider *gasSlider;

@property (nonatomic, assign) long long gasLimite;

//guojihua
@property (weak, nonatomic) IBOutlet UILabel *feeSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *slowLabel;
@property (weak, nonatomic) IBOutlet UILabel *fastLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommandLabel;


@end

@implementation TPOSTransactionGasView

+ (TPOSTransactionGasView *)transactionGasViewWithGasLimite:(long long)gasLimite defaultPrice:(long long)defaultPrice {
    //TODO: eth gas目前还是写死的imtoken的值，最小gasPrice和最大gasPrice也是写死的imtoken的值
    TPOSTransactionGasView *transactionGasView = [[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionGasView" owner:nil options:nil].firstObject;
    transactionGasView.frame = CGRectMake(15, 0, kScreenWidth-30, 275);
    transactionGasView.bottomOffset = 15;
    transactionGasView.layer.cornerRadius = 10;
    transactionGasView.layer.masksToBounds = YES;
    transactionGasView.gasSlider.minimumValue = gasLimite * 8;
    transactionGasView.gasSlider.maximumValue = gasLimite * 99.99;
    transactionGasView.gasSlider.value = gasLimite * defaultPrice;
    transactionGasView.gasLimite = gasLimite;
    transactionGasView.gasUnitLabel.text = @"ETH";
    [transactionGasView.gasSlider setNeedsDisplay];
    [transactionGasView updateEthGas];
    return transactionGasView;
}

+ (TPOSTransactionGasView *)transactionViewWithMinFee:(CGFloat)min maxFee:(CGFloat)max recommentFee:(CGFloat)recomment {
    TPOSTransactionGasView *transactionGasView = [[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionGasView" owner:nil options:nil].firstObject;
    transactionGasView.frame = CGRectMake(15, 0, kScreenWidth-30, 275);
    transactionGasView.bottomOffset = 15;
    transactionGasView.layer.cornerRadius = 10;
    transactionGasView.layer.masksToBounds = YES;
    transactionGasView.gasSlider.minimumValue = min;
    transactionGasView.gasSlider.maximumValue = max;
    transactionGasView.gasSlider.value = recomment;
    transactionGasView.gasUnitLabel.text = @"SWT";
    [transactionGasView.gasSlider setNeedsDisplay];
    [transactionGasView updateFee];
    return transactionGasView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _confirmButton.layer.cornerRadius = 4;
    _gasValieLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    [self changeLanguage];
}

- (void)changeLanguage {
    self.feeSettingLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"fee_setting"];
    self.slowLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"gas_slow"];
    self.fastLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"gas_fast"];
    self.recommandLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"gas_rec"];
    [self.confirmButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] forState:UIControlStateNormal];
}

- (IBAction)closeAction {
    [self hide];
}

- (IBAction)valueChange:(UISlider *)sender {
    if (_jtChooseGasPrice) {
        [self updateFee];
    } else {
        [self updateEthGas];
    }
}

- (void)updateFee {
    _gasValieLabel.text = [NSString stringWithFormat:@"%.6f",_gasSlider.value];
}

- (void)updateEthGas {
    __weak typeof(self) weakSelf = self;
    long long gasLimite = _gasLimite;
    long long currentGasPrice = _gasSlider.value/_gasLimite;
    [[TPOSWeb3Handler sharedManager] weiChangeToTokenOfTokenType:nil withCount:[NSString stringWithFormat:@"%lld000000000",gasLimite*currentGasPrice] callBack:^(id responseObject) {
        weakSelf.gasValieLabel.text = [NSString stringWithFormat:@"%@",responseObject];
    }];
}

- (IBAction)confirmAction {
    if (_ethChooseGasPrice) {
        _ethChooseGasPrice(_gasLimite,_gasSlider.value/_gasLimite);
    } else if (_jtChooseGasPrice) {
        _jtChooseGasPrice(_gasSlider.value);
    }
    [self hide];
}

@end
