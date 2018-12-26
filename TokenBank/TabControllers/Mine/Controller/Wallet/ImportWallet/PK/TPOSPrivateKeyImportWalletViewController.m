//
//  TPOSPrivateKeyImportWalletViewController
//  TokenBank
//
//  Created by MarcusWoo on 10/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSPrivateKeyImportWalletViewController.h"
#import "TPOSRetrivePathCell.h"
#import "TPOSH5ViewController.h"
#import "UIImage+TPOS.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSBlockChainModel.h"
#import "TPOSWeb3Handler.h"
#import "TPOSJTManager.h"
#import "TPOSWalletDao.h"
#import "TPOSWalletModel.h"
#import "NSString+TPOS.h"
#import "TPOSJTWallet.h"
#import "TPOSBlockChainModel.h"
#import "TPOSPasswordView.h"
#import "NJOPasswordStrengthEvaluator.h"

@import Toast;
@import SVProgressHUD;

@interface TPOSPrivateKeyImportWalletViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *pkBg;
@property (weak, nonatomic) IBOutlet UITextView *pkTextview;
@property (weak, nonatomic) IBOutlet UILabel *pkPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *chainNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmTextfield;
@property (weak, nonatomic) IBOutlet UITextField *hintTextfield;
@property (weak, nonatomic) IBOutlet UIButton *confirmProtocolButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *startImportButton;
@property (weak, nonatomic) IBOutlet UIButton *chainTypeButton;

@property (nonatomic, strong) TPOSWalletDao *walletDao;

//localized
@property (weak, nonatomic) IBOutlet UILabel *foudationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet UILabel *pwdTipsLabel;

@property (nonatomic, assign) BOOL importing;

@end

@implementation TPOSPrivateKeyImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changeLanguage {
    self.pkPlaceholder.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_private_key"];
    self.foudationLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_foundation"];
    self.pwdLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"set_pwd"];
    self.repeatLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"repeat_pwd"];
    self.hintLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_hint"];
    [self.confirmProtocolButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"read_agree"] forState:UIControlStateNormal];
    [self.protocolDetailButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"service_privacy"] forState:UIControlStateNormal];
    self.hintTextfield.placeholder = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_optional"];
    [self.startImportButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_start"] forState:UIControlStateNormal];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pkBg.layer.borderWidth = 0.5;
    self.pkBg.layer.borderColor = [UIColor colorWithHex:0xd8d8d8].CGColor;
    self.pkBg.layer.cornerRadius = 2;
    self.pkBg.layer.masksToBounds = YES;
    self.pkTextview.delegate = self;
    
    [self.startImportButton setBackgroundImage:[UIImage tb_imageWithColor:[UIColor colorWithHex:0x2890FE] andSize:CGSizeMake(kScreenWidth, 47)] forState:UIControlStateNormal];
    self.startImportButton.layer.cornerRadius = 4;
    self.startImportButton.layer.masksToBounds = YES;
    self.startImportButton.enabled = NO;
    
    [self.pwdTextfield addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdConfirmTextfield addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.pwdTextfield.delegate = self;
    
    if (self.blockchain) {
        self.chainNameLabel.text = self.blockchain.desc;
    }
}

- (void)checkStartButtonStatus {
    BOOL enable = YES;
    if (self.pkTextview.text.length <= 0) {
        enable = NO;
    }
    if (self.pwdTextfield.text.length < 8) {
        enable = NO;
    }
    if (self.pwdConfirmTextfield.text.length < 8) {
        enable = NO;
    }
//    if (!self.confirmProtocolButton.isSelected) {
//        enable = NO;
//    }
    
    if (_importing) {
        enable = NO;
    }
    
    self.startImportButton.enabled = enable;
}

#pragma mark - ButtonEvents

- (IBAction)onChainTypeButtonTapped:(id)sender {
    TPOSLog(@"TODO : 进入区块体系选择");
}

- (IBAction)onConfirmProtocolButtonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [self checkStartButtonStatus];
}

- (IBAction)onProtocolButtonTapped:(id)sender {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/terms/index.html";
    h5VC.viewType = kH5ViewTypeTerms;
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"term_service"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

- (IBAction)onStartImportButtonTapped:(id)sender {
    if (![self.pwdTextfield.text isEqualToString:self.pwdConfirmTextfield.text]) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_not_match"] duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (!self.confirmProtocolButton.isSelected) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"read_first"] duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    //TODO: - 开始导入
    [self injectAction];
}

- (void)injectAction {
    
    if (_importing) {
        return;
    }
    
    __block BOOL exist = NO;
    NSString *privateKey = _pkTextview.text;
    [self.walletDao findAllWithComplement:^(NSArray<TPOSWalletModel *> *walletModels) {
        [walletModels enumerateObjectsUsingBlock:^(TPOSWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.privateKey isEqualToString:privateKey]) {
                exist = YES;
                *stop = YES;
            }
        }];
    }];
    
    if (exist) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_exist"]];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD showWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"importing"]];
    
    NSString *pkString = _pkTextview.text;
    
    _importing = YES;
    [self checkStartButtonStatus];
    
    if ([ethChain isEqualToString:_blockchain.hid]) {
        if (![pkString hasPrefix:@"0x"]) {
            pkString = [NSString stringWithFormat:@"0x%@",pkString];
        }
        [[TPOSWeb3Handler sharedManager] retrieveAccoutWithPrivateKey:pkString callBack:^(id responseObject) {
            NSString *address = responseObject[@"address"];
            NSString *privateKey = responseObject[@"privateKey"];
            if (address && privateKey) {
                [weakSelf createWalletToServerWithAddress:address toLocalWithPrivateKey:privateKey mnemonic:nil blockchainId:ethChain];
            } else {
                [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_fail"]];
                weakSelf.importing = NO;
                [weakSelf checkStartButtonStatus];
            }
        }];
    } else if ([swtcChain isEqualToString:_blockchain.hid]) {
        //JT
        [[TPOSJTManager shareInstance] retrieveWalletWithPk:pkString completion:^(TPOSJTWallet *wallet, NSError *error) {
            if (!error) {
                [weakSelf createWalletToServerWithAddress:wallet.address toLocalWithPrivateKey:wallet.secret mnemonic:nil blockchainId:swtcChain];
            } else {
                [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_fail"]];
                weakSelf.importing = NO;
                [weakSelf checkStartButtonStatus];
            }
        }];
    }
}

- (void)createWalletToServerWithAddress:(NSString *)address toLocalWithPrivateKey:(NSString *)privateKey mnemonic:(NSString *)mnemonic blockchainId:(NSString *)blockchainId {
    NSString *walletName = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pk_wallet"];
    NSString *password = [self.pwdTextfield.text tb_md5];
    NSString *enprivateKey = [privateKey tb_encodeStringWithKey:password];
    NSString *hit = _hintTextfield.text;
    __weak typeof(self) weakSelf = self;
    weakSelf.importing = NO;
    NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *walletId = [NSString stringWithFormat:@"%.0f", milisecondedDate];
    TPOSWalletModel *walletModel = [TPOSWalletModel new];
    walletModel.walletName = walletName;
    walletModel.address = address;
    walletModel.privateKey = enprivateKey;
    walletModel.password = password;
    walletModel.passwordTips = hit;
    walletModel.walletId = walletId;
    walletModel.mnemonic = mnemonic;
    walletModel.blockChainId = blockchainId;
    walletModel.dbVersion = kDBVersion;
    walletModel.backup = YES;
    uint32_t index = arc4random()%5+1;
    walletModel.walletIcon = [NSString stringWithFormat:@"icon_wallet_avatar_%u",index];
    //存到本地
    [weakSelf.walletDao addWalletWithWalletModel:walletModel complement:^(BOOL success) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_succ"]];
            [weakSelf responseLeftButton];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCreateWalletNotification object:walletModel];
        } else {
            [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_fail"]];
            weakSelf.importing = NO;
            [weakSelf checkStartButtonStatus];
        }
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.pkPlaceholder.hidden = textView.text.length > 0;
    [self checkStartButtonStatus];
}

- (void)textFiledDidChanged:(UITextField *)textfield {
    [self checkStartButtonStatus];
    
    if ([self.pwdTextfield isEqual:textfield]) {
        [self showPasswordTipLabelWithField:textfield];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.pwdTextfield isEqual:textField]) {
        [self showPasswordTipLabelWithField:textField];
    }
}

- (void)showPasswordTipLabelWithField:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.pwdTipsLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_length_tip"];
    } else {
        if ([self judgePasswordStrength:textField.text] == eWeakPassword) {
            self.pwdTipsLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_length_weak"];
        } else {
            self.pwdTipsLabel.text = @"";
        }
    }
}

#pragma mark - Setter
- (void)setScanResult:(NSString *)scanResult {
    _scanResult = scanResult;
    self.pkTextview.text = scanResult;
    if (scanResult.length > 0) {
        self.pkPlaceholder.hidden = YES;
    }
}

- (TPOSWalletDao *)walletDao {
    if (!_walletDao) {
        _walletDao = [TPOSWalletDao new];
    }
    return _walletDao;
}

#pragma mark - TODO
- (PasswordEnum)judgePasswordStrength:(NSString*)password {
    
    if (password.length == 0) {
        return eEmptyPassword;
    }
    
    NJOPasswordStrength strength = [NJOPasswordStrengthEvaluator strengthOfPassword:password];
    
    PasswordEnum pwdStrong = eWeakPassword;
    switch (strength) {
        case NJOVeryWeakPasswordStrength:
        case NJOWeakPasswordStrength:
            pwdStrong = eWeakPassword;
            break;
        case NJOReasonablePasswordStrength:
            pwdStrong = eSosoPassword;
            break;
        case NJOStrongPasswordStrength:
            pwdStrong = eGoodPassword;
            break;
        case NJOVeryStrongPasswordStrength:
            pwdStrong = eSafePassword;
            break;
        default:
            break;
    }
    
    return pwdStrong;
}

@end
