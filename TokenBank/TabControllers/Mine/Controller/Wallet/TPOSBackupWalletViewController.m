//
//  BackupWalletViewController.m
//  TPOSUIProject
//
//  Created by yf on 06/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBackupWalletViewController.h"
#import "TPOSCreateMemonicViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+TPOS.h"
#import "TPOSWalletModel.h"

@interface TPOSBackupWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipForBackupLabel;

@property (weak, nonatomic) IBOutlet UIButton *backupBtn;
@end

@implementation TPOSBackupWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_wallet"];
    
    [self.backupBtn setBackgroundImage:[UIImage tb_imageWithColor:[UIColor colorWithHex:0x2890FE] andSize:CGSizeMake(135, 47)] forState:UIControlStateNormal];
    self.backupBtn.layer.cornerRadius = 5.0f;
    self.backupBtn.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)clickBackupBtn:(UIButton *)sender {
    TPOSCreateMemonicViewController *privateKeyVC = [[TPOSCreateMemonicViewController alloc] init];
    privateKeyVC.walletModel = _walletModel;
    privateKeyVC.privateWords = [_mnemonic componentsSeparatedByString:@" "];
    [self.navigationController pushViewController:privateKeyVC animated:YES];
}

@end
