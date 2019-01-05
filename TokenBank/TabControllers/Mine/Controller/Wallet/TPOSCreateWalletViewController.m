//
//  TPOSCreateWalletViewController.m
//  TPOSUIProject
//
//  Created by yf on 06/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSCreateWalletViewController.h"
#import "TPOSBackupWalletViewController.h"
#import "TPOSPasswordView.h"
#import "UIColor+Hex.h"
#import "TPOSH5ViewController.h"
#import "TPOSWeb3Handler.h"
#import "NSString+TPOS.h"
#import "TPOSWalletDao.h"
#import "TPOSWalletModel.h"
#import "TPOSMacro.h"
#import "TPOSThreadUtils.h"
#import "TPOSContext.h"
#import "TPOSBlockChainModel.h"
#import "TPOSChooseTokenSystemViewController.h"
#import "NJOPasswordStrengthEvaluator.h"
#import "UIImage+TPOS.h"
#import "TPOSBackupAlert.h"
#import <jcc_oc_base_lib/JingtumWallet.h>
#import <jcc_oc_base_lib/JTWalletManager.h>
#import <jcc_oc_base_lib/JccChains.h>

@import SVProgressHUD;
@import IQKeyboardManager;

#define itemHeight 66

@interface TPOSCreateWalletViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createWalletBtn;

@property (weak, nonatomic) IBOutlet UIView *TipBackView;
@property (weak, nonatomic) IBOutlet UIView *pointOne;
@property (weak, nonatomic) IBOutlet UIView *pointTwo;


@property (weak, nonatomic) IBOutlet UIView *walletView;
@property (weak, nonatomic) IBOutlet UILabel *walletTypeLabel;

@property (weak, nonatomic) IBOutlet UITextField *walletNameField;

@property (weak, nonatomic) IBOutlet UIView *passwordContentView;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (weak, nonatomic) IBOutlet UITextField *commentLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;

@property (strong, nonatomic) TPOSPasswordView *passwordStrongView;

@property (assign, nonatomic) BOOL chooseType;

@property (nonatomic, strong) TPOSWalletDao *walletDao;

@property (assign, nonatomic) BOOL creating;
@property (weak, nonatomic) IBOutlet UILabel *pwdTipLabel;

//localize
@property (weak, nonatomic) IBOutlet UILabel *tipOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *foundationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UIButton *termButotn;


@end

@implementation TPOSCreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTopHeaderView];
    [self createInitView];
    [self setupData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_wallet"];
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)changeLanguage {
    self.tipOneLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"tip_one"];
    self.tipTwoLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"tip_two"];
    self.foundationLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_foundation"];
    self.nameLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_name"];
    self.pwdLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"set_pwd"];
    self.confirmLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"repeat_pwd"];
    self.tipLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_hint"];
    self.optionLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_optional"];
    [self.termButotn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"service_privacy"] forState:UIControlStateNormal];
    [self.agreenBtn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"read_agree"] forState:UIControlStateNormal];
}

#pragma mark - private method
- (void)setupData {
    if (self.blockChainModel) {
        self.chooseType = YES;
        self.walletTypeLabel.text = self.blockChainModel.desc;
    } else {
        self.chooseType = NO;
        self.walletTypeLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_wallet_chain_type"];
    }
}

- (void)createInitView{
//    self.navigationItem.title = NSLocalizedString([[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"创建钱包", [[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"创建钱包");
    self.pwdTipLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.createWalletBtn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_wallet"] forState:UIControlStateNormal];
    [self.createWalletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.createWalletBtn.layer.cornerRadius = 5.0;
    self.createWalletBtn.enabled = NO;
    [self.createWalletBtn setBackgroundColor:[UIColor colorWithHex:0x2890FE alpha:0.5]];
    
    [self addTapGuestureForSelectWallet];
    
    self.commentLabel.delegate = self;
    [self.walletNameField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.walletNameField.returnKeyType = UIReturnKeyNext;
    self.walletNameField.borderStyle = UITextBorderStyleNone;
    
    self.setPasswordField.returnKeyType = UIReturnKeyNext;
    self.setPasswordField.secureTextEntry = YES;
    self.setPasswordField.borderStyle = UITextBorderStyleNone;
    [self.setPasswordField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.setPasswordField.delegate = self;
    
    self.confirmPwdField.returnKeyType = UIReturnKeyNext;
    self.confirmPwdField.secureTextEntry = YES;
    self.confirmPwdField.borderStyle = UITextBorderStyleNone;
    [self.confirmPwdField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];

    
    self.commentLabel.returnKeyType = UIReturnKeyDone;
    self.commentLabel.borderStyle = UITextBorderStyleNone;
    
    self.passwordStrongView = [[TPOSPasswordView alloc] initWithFrame: CGRectMake(kScreenWidth - 20 - 60, 0, 60, self.passwordContentView.frame.size.height)];
    [self.passwordContentView addSubview:self.passwordStrongView];
    
    if (self.navigationController.viewControllers.firstObject == self) {
        [self addLeftBarButtonImage:[[UIImage imageNamed:@"icon_guanbi"] tb_imageWithTintColor:[UIColor whiteColor]] action:@selector(responseLeftButton)];
    }
    
}

- (void)createTopHeaderView{
    self.TipBackView.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
    self.pointOne.layer.cornerRadius = self.pointOne.frame.size.width/2;
    self.pointTwo.layer.cornerRadius = self.pointTwo.frame.size.width/2;
}

- (void)addTapGuestureForSelectWallet{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selecteWhatKindOfWallet)];
    [self.walletView addGestureRecognizer:tapGesture];
    
    self.walletTypeLabel.userInteractionEnabled = YES;
}

- (IBAction)clickCreateWalletBtn:(UIButton *)sender {
    
    NSString *alertTips = @"";
    
    if (!self.chooseType) {
        alertTips = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_wallet_chain_type"];
    } else if (self.walletNameField.text.length == 0
               || self.setPasswordField.text.length == 0
               || self.confirmPwdField.text.length == 0) {
        alertTips = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"complete_info"];
    } else if (self.setPasswordField.text.length < 8
               || self.confirmPwdField.text.length < 8) {
        alertTips = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"at_least_8"];
    } else if (![self.setPasswordField.text isEqualToString:self.confirmPwdField.text]) {
        alertTips = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_not_match"];
    } else if (!self.agreenBtn.isSelected) {
        alertTips = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"read_and_agree"];
    }
    if (alertTips.length > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"Tips"] message:alertTips preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD showWithStatus:nil];
    self.creating = YES;
    [self checkCreateButtonStatus];
    if ([ethChain isEqualToString:_blockChainModel.hid]) {
        //ETH
        [[TPOSWeb3Handler sharedManager] createMnemonicWalletWithDerivePath:nil callback:^(id responseObject) {
            NSString *address = responseObject[@"address"];
            NSString *privateKey = responseObject[@"privateKey"];
            NSString *mnemonic = responseObject[@"mnemonic"];
            if (address && privateKey && mnemonic) {
                [weakSelf createWalletToServerWithAddress:address toLocalWithPrivateKey:privateKey mnemonic:mnemonic blockchainId:ethChain];
            } else {
                [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_fail"]];
                weakSelf.creating = NO;
                [weakSelf checkCreateButtonStatus];
            }
        }];
    } else if ([swtcChain isEqualToString:_blockChainModel.hid]) {
        [[JTWalletManager shareInstance] createWallet:SWTC_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
            if (!error) {
                [weakSelf createWalletToServerWithAddress:wallet.address toLocalWithPrivateKey:wallet.secret mnemonic:nil blockchainId:swtcChain];
            } else {
                [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_fail"]];
                weakSelf.creating = NO;
                [weakSelf checkCreateButtonStatus];
            }
        }];
    }
}

- (void)createWalletToServerWithAddress:(NSString *)address toLocalWithPrivateKey:(NSString *)privateKey mnemonic:(NSString *)mnemonic blockchainId:(NSString *)blockchainId {
    NSString *walletName = self.walletNameField.text;
    NSString *password = self.setPasswordField.text;
    NSString *passwordPrivate = [password tb_md5];
    NSString *enPrivateKey = [privateKey tb_encodeStringWithKey:passwordPrivate];
    NSString *tips = self.commentLabel.text;
    __weak typeof(self) weakSelf = self;
    NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *walletId = [NSString stringWithFormat:@"%.0f", milisecondedDate];
    TPOSWalletModel *walletModel = [TPOSWalletModel new];
    walletModel.walletName = walletName;
    walletModel.address = address;
    walletModel.privateKey = enPrivateKey;
    walletModel.password = passwordPrivate;
    walletModel.passwordTips = tips;
    walletModel.walletId = walletId;
    walletModel.mnemonic = [mnemonic tb_encodeStringWithKey:passwordPrivate];
    walletModel.blockChainId = blockchainId;
    walletModel.dbVersion = kDBVersion;
    uint32_t index = arc4random()%5+1;
    walletModel.walletIcon = [NSString stringWithFormat:@"icon_wallet_avatar_%u",index];
    //存到本地
    [weakSelf.walletDao addWalletWithWalletModel:walletModel complement:^(BOOL success) {
        if (success) {
            [TPOSThreadUtils runOnMainThread:^{
                [SVProgressHUD showSuccessWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_succ"]];
                weakSelf.creating = NO;
                [weakSelf pushToBackupWalletWithWalletModel:walletModel];
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_fail"]];
            weakSelf.creating = NO;
            [weakSelf checkCreateButtonStatus];
        }
    }];
}

- (void)pushToBackupWalletWithWalletModel:(TPOSWalletModel *)walletModel {
    if (_ignoreBackup) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateWalletNotification object:walletModel];
        [self responseLeftButton];
        return;
    }
    [TPOSBackupAlert showWithWalletModel:walletModel inView:self.view.window.rootViewController.view navigation:(id)self.view.window.rootViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCreateWalletNotification object:walletModel];
    [self responseLeftButton];
}

- (void)pushToWalletType {
    TPOSChooseTokenSystemViewController *chooseTokenSystemViewController = [[TPOSChooseTokenSystemViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    chooseTokenSystemViewController.chooseAction = ^(TPOSBlockChainModel *blockChainModel) {
        weakSelf.chooseType = YES;
        weakSelf.blockChainModel = blockChainModel;
        weakSelf.walletTypeLabel.text = blockChainModel.desc;
    };
    [self.navigationController pushViewController:chooseTokenSystemViewController animated:YES];
}

- (IBAction)clickProtocolButton:(id)sender {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/terms/index.html";
    h5VC.viewType = kH5ViewTypeTerms;
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"service_privacy"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

- (IBAction)clickAgreenBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self checkCreateButtonStatus];
}

- (void)checkCreateButtonStatus {
    BOOL enable = YES;
    if (_walletNameField.text.length == 0) {
        enable = NO;
    }
    if (_setPasswordField.text.length == 0 || _confirmPwdField.text.length == 0) {
        enable = NO;
    }
    
    if (_creating) {
        enable = NO;
    }
    
    self.createWalletBtn.enabled = enable;
    [self.createWalletBtn setBackgroundColor:enable?[UIColor colorWithHex:0x2890FE alpha:1]:[UIColor colorWithHex:0x2890FE alpha:0.5]];
}

- (void)selecteWhatKindOfWallet{
    //当选择了那个钱包后   把type 赋值为正确的value
    [self pushToWalletType];
}

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

- (BOOL) judgeRange:(NSArray*)termArray Password:(NSString*)password{
    NSRange range;
    BOOL result = NO;
    for(int i=0; i<[termArray count]; i++){
        range = [password rangeOfString:[termArray objectAtIndex:i]];
        if(range.location != NSNotFound){
            result =YES;
        }
    }
    return result;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.setPasswordField]) {
        [self showPasswordTipLabelWithField:textField];
    }
}

- (void)textFieldDidChanged:(UITextField *)textfield {
    
    if ([textfield isEqual:self.setPasswordField]) {
        [self.passwordStrongView showPasswordViewEffectWith:[self judgePasswordStrength:textfield.text]];
        [self showPasswordTipLabelWithField:textfield];
    }
    [self checkCreateButtonStatus];
}

- (void)showPasswordTipLabelWithField:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.pwdTipLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_length_tip"];
    } else {
        if ([self judgePasswordStrength:textField.text] == eWeakPassword) {
            self.pwdTipLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_length_weak"];
        } else {
            self.pwdTipLabel.text = @"";
        }
    }
}

- (TPOSWalletDao *)walletDao {
    if (!_walletDao) {
        _walletDao = [TPOSWalletDao new];
    }
    return _walletDao;
}


@end
