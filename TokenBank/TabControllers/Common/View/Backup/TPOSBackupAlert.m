//
//  TPOSBackupAlert.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSBackupAlert.h"
#import "TPOSWalletModel.h"
#import "TPOSLocalizedHelper.h"
#import "NSString+TPOS.h"
#import "TPOSCreateMemonicViewController.h"
#import "TPOSExportPrivateKeyNoteView.h"
#import "TPOSNavigationController.h"
#import "TPOSWalletDao.h"
#import "TPOSMacro.h"

@interface TPOSBackupAlert()

@property (nonatomic, strong) TPOSWalletModel *walletModel;

@property (nonatomic, weak) UINavigationController *navi;
@property (nonatomic, weak) UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *walletLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *backTipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation TPOSBackupAlert

+ (TPOSBackupAlert *)showWithWalletModel:(TPOSWalletModel *)walletModel inView:(UIView *)view navigation:(UINavigationController *)navi {
    TPOSBackupAlert *backupAlert = [[NSBundle mainBundle] loadNibNamed:@"TPOSBackupAlert" owner:nil options:nil].firstObject;
    backupAlert.walletModel = walletModel;
    backupAlert.walletLineLabel.text = [NSString stringWithFormat:@"%@%@%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_wallet_line_prefix"],walletModel.walletName,[[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_wallet_line_suffix"]];
    backupAlert.navi = navi;
    backupAlert.container = view;
    [backupAlert showWithAnimate:TPOSAlertViewAnimateCenterPop inView:view];
    return backupAlert;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.canDismissByTouchBackground = NO;
    _backTipsLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_tips"];
    [_backButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_now"] forState:UIControlStateNormal];
}

- (IBAction)backupAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_pwd"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(alertController) weakAlertController = alertController;
    [alertController addAction:[UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([[weakAlertController.textFields.firstObject.text tb_md5] isEqualToString:weakSelf.walletModel.password]) {
            [weakSelf nextAction];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_error"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [weakSelf.navi presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    [self.navi presentViewController:alertController animated:YES completion:nil];
}

- (void)nextAction {
    if ([ethChain isEqualToString:_walletModel.blockChainId]) { //ETH
        TPOSCreateMemonicViewController *createPrivateKeyViewController = [[TPOSCreateMemonicViewController alloc] init];
        createPrivateKeyViewController.walletModel = _walletModel;
        if (_walletModel.dbVersion < 1) {
            createPrivateKeyViewController.privateWords = [_walletModel.mnemonic componentsSeparatedByString:@" "];
        } else {
            createPrivateKeyViewController.privateWords = [[_walletModel.mnemonic tb_encodeStringWithKey:_walletModel.password] componentsSeparatedByString:@" "];
        }
        
        [self.navi presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:createPrivateKeyViewController] animated:YES completion:nil];
        [self hide];
    } else { //JT
        TPOSExportPrivateKeyNoteView *exportPrivateKeyNoteView = [TPOSExportPrivateKeyNoteView exportPrivateKeyNoteViewWithWalletModel:self.walletModel];
        [exportPrivateKeyNoteView showWithAnimate:TPOSAlertViewAnimateCenterPop inView:self.container];
        self.walletModel.backup = YES;
        __weak typeof(self) weakSelf = self;
        [[[TPOSWalletDao alloc] init] updateWalletWithWalletModel:self.walletModel complement:^(BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBackupWalletNotification object:weakSelf.walletModel];
            }
            [weakSelf hide];
        }];
    }
}

@end
