//
//  TPOSTransactionConfirmView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionConfirmView.h"
#import "UIViewController+TPOS.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSTransactionConfirmView()

//@property (nonatomic, copy) void (^confirmAction)(NSString *password);

@property (weak, nonatomic) IBOutlet UILabel *fromLbael;

@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

//国际化
@property (weak, nonatomic) IBOutlet UILabel *transDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *transInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *inAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWallet;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@end

@implementation TPOSTransactionConfirmView

- (void)awakeFromNib {
    [super awakeFromNib];
    _confirmButton.layer.cornerRadius = 4;
    _confirmButton.layer.masksToBounds = YES;
    
    [self changeLanguage];
}

- (void)changeLanguage {
    self.transDetailLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_detail"];
    self.transInfoLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_info"];
    self.inAddLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_out"];
    self.payWallet.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pay_wallet"];
    self.feeLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"miner_fee"];
    self.amountLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"amount"];
    [self.confirmButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm_trans"] forState:UIControlStateNormal];
}

+ (TPOSTransactionConfirmView *)transactionConfirmView {
    TPOSTransactionConfirmView *transactionConfirmView = [[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionConfirmView" owner:nil options:nil].firstObject;
//    transactionConfirmView.confirmAction = confirmAction;
    transactionConfirmView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(transactionConfirmView.frame));
    return transactionConfirmView;
}

- (IBAction)confimAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_pwd"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"cancel"]
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
          if ([self.delegate respondsToSelector:@selector(TPOSTransactionConfirmView:didConfirmPassword:)]) {
              [self.delegate TPOSTransactionConfirmView:self didConfirmPassword:alertController.textFields.firstObject.text];
          }
      }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [[UIViewController tb_topPresentedViewController] presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)closeAction {
    [super hide];
}

- (void)fillFromLabel:(NSString *)from {
    self.fromLbael.text = from;
}

- (void)fillToLabel:(NSString *)to {
    self.toLabel.text = to;
}

- (void)fillMinerfee:(NSString *)minerfee {
    self.gasLabel.text = minerfee;
}

- (void)fillGasDescLabel:(NSString *)gasDesc {
    self.gasDescLabel.text = gasDesc;
}

- (void)fillMoneyLabel:(NSString *)money {
    self.moneyLabel.text = money;
}

@end
