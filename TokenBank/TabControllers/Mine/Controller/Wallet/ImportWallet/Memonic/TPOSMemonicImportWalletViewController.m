//
//  TPOSMemonicImportWalletViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 10/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSMemonicImportWalletViewController.h"
#import "TPOSRetrivePathCell.h"
#import "TPOSH5ViewController.h"
#import "UIImage+TPOS.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSBlockChainModel.h"
#import "TPOSWeb3Handler.h"
#import "NSString+TPOS.h"
#import "TPOSWalletModel.h"
#import "TPOSWalletDao.h"
#import "NJOPasswordStrengthEvaluator.h"
#import "TPOSPasswordView.h"


@import Toast;
@import SVProgressHUD;

@interface TPOSMemonicImportWalletViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *memonicBg;
@property (weak, nonatomic) IBOutlet UITextView *memonicTextview;
@property (weak, nonatomic) IBOutlet UILabel *memonicPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *chainNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pathTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmTextfield;
@property (weak, nonatomic) IBOutlet UITextField *hintTextfield;
@property (weak, nonatomic) IBOutlet UIButton *confirmProtocolButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *startImportButton;
@property (weak, nonatomic) IBOutlet UIButton *chainTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *pathButton;
@property (weak, nonatomic) IBOutlet UITableView *pathTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pathTableHeightContraints;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *paths;

@property (nonatomic, strong) TPOSWalletDao *walletDao;

//localized
@property (weak, nonatomic) IBOutlet UILabel *foundataionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdStrengthLabel;

@property (nonatomic, assign) BOOL importing;

@end

@implementation TPOSMemonicImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupData];
    [self setupSubviews];
}

- (void)changeLanguage {
    self.memonicPlaceholder.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_mnemonic_words"];
    self.foundataionLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_foundation"];
    self.pathLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"derive_path"];
    self.pwdLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"set_pwd"];
    self.repeatLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"repeat_pwd"];
    self.hintLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_hint"];
    [self.confirmProtocolButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"read_agree"] forState:UIControlStateNormal];
    [self.protocolDetailButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"service_privacy"] forState:UIControlStateNormal];
    self.hintTextfield.placeholder = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_optional"];
    [self.startImportButton setTitle:[[TPOSLocalizedHelper standardHelper]stringWithKey:@"import_start"] forState:UIControlStateNormal];
    self.hintTextfield.placeholder = [[TPOSLocalizedHelper standardHelper]stringWithKey:@"pwd_optional"];
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupData {
    NSString *selfPath = [NSString stringWithFormat:@"m/44'/60'/1'/0/0 %@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"custom_path"]];
    
    self.paths = @[@"m/44'/60'/0'/0 Ledger (ETH)",
                   @"m/44'/60'/0'/0/0 Jaxx,Metamask (ETH)",
                   selfPath];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.memonicBg.layer.borderWidth = 0.5;
    self.memonicBg.layer.borderColor = [UIColor colorWithHex:0xd8d8d8].CGColor;
    self.memonicBg.layer.cornerRadius = 2;
    self.memonicBg.layer.masksToBounds = YES;
    self.memonicTextview.delegate = self;
    
    self.pathTextfield.enabled = NO;
    self.pathTextfield.text = [self.paths objectAtIndex:1];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    self.pathTable.layer.shadowOpacity = 0.1;
    self.pathTable.layer.shadowRadius = 4;
    self.pathTable.layer.shadowColor = [UIColor colorWithHex:0x333333].CGColor;
    self.pathTable.layer.borderWidth = 0.5;
    self.pathTable.layer.borderColor = [UIColor colorWithHex:0xd8d8d8].CGColor;
    [self.pathTable registerNib:[UINib nibWithNibName:@"TPOSRetrivePathCell" bundle:nil] forCellReuseIdentifier:@"TPOSRetrivePathCell"];
    self.pathTable.hidden = YES;
    
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
    if (self.memonicTextview.text.length <= 0) {
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

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPOSRetrivePathCell *cell = (TPOSRetrivePathCell *)[tableView dequeueReusableCellWithIdentifier:@"TPOSRetrivePathCell" forIndexPath:indexPath];
    cell.pathLabel.text = [self.paths objectAtIndex:indexPath.row];
    BOOL selected = indexPath.row == self.selectedIndexPath.row;
    cell.checkIcon.hidden = !selected;
    cell.pathLabel.textColor = [UIColor colorWithHex:selected?0x2890FE:0x333333];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    self.pathTable.hidden = YES;
    self.pathTextfield.enabled = indexPath.row == 2;
    if (indexPath.row == 2) {
        self.pathTextfield.text = @"m/44'/60'/1'/0/0";
    } else {
        self.pathTextfield.text = [self.paths objectAtIndex:indexPath.row];
    }
}

#pragma mark - ButtonEvents

- (IBAction)onChainTypeButtonTapped:(id)sender {
    TPOSLog(@"TODO : 进入区块体系选择");
}

- (IBAction)onPathButtonTapped:(id)sender {
    
    if (self.pathTable.hidden) {
        self.pathTable.hidden = NO;
        [self.pathTable reloadData];
    } else {
        self.pathTable.hidden = YES;
    }
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
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"service_privacy"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

- (IBAction)onStartImportButtonTapped:(id)sender {
    if (_importing) {
        return;
    }
    
    if (!self.confirmProtocolButton.isSelected) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"read_first"]
                    duration:1.0
                    position:CSToastPositionCenter];
        return;
    }
    
    NSString *mnemonicWords = self.memonicTextview.text;
    NSArray *words = [mnemonicWords componentsSeparatedByString:@" "];
    if (words.count < 12) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"illegal_mnem"]
                    duration:1.0
                    position:CSToastPositionCenter];
        return;
    }
    
    if (![self.pwdTextfield.text isEqualToString:self.pwdConfirmTextfield.text]) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_not_match"]
                    duration:1.0
                    position:CSToastPositionCenter];
        return;
    }

    _importing = YES;
    [self checkStartButtonStatus];
    [SVProgressHUD showWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"importing"]];
    __weak typeof(self) weakSelf = self;
    NSString *path = [_pathTextfield.text componentsSeparatedByString:@" "].firstObject;
    [[TPOSWeb3Handler sharedManager] retrieveWalletFromMnemonic:_memonicTextview.text andDerivePath:path callback:^(id responseObject) {
        
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
}

- (void)createWalletToServerWithAddress:(NSString *)address toLocalWithPrivateKey:(NSString *)privateKey mnemonic:(NSString *)mnemonic blockchainId:(NSString *)blockchainId {
    NSString *walletName = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"m_new_wallet"];
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
    self.memonicPlaceholder.hidden = textView.text.length > 0;
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
        self.pwdStrengthLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_length_tip"];
    } else {
        if ([self judgePasswordStrength:textField.text] == eWeakPassword) {
            self.pwdStrengthLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_length_weak"];
        } else {
            self.pwdStrengthLabel.text = @"";
        }
    }
}

#pragma mark - Setter
- (void)setScanResult:(NSString *)scanResult {
    _scanResult = scanResult;
    self.memonicTextview.text = scanResult;
    if (scanResult.length > 0) {
        self.memonicPlaceholder.hidden = YES;
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
