//
//  TPOSEditWalletViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSEditWalletViewController.h"
#import "UIColor+Hex.h"
#import "TPOSEditPasswordViewController.h"
#import "TPOSExportPrivateKeyNoteView.h"
#import "TPOSWalletModel.h"
#import "TPOSWalletDao.h"
#import "TPOSMacro.h"
#import "TPOSThreadUtils.h"
#import "NSString+TPOS.h"
#import "TPOSCreateMemonicViewController.h"
#import "TPOSNavigationController.h"
#import "TPOSQRCodeReceiveViewController.h"
#import "TPOSBlockChainModel.h"

@import SVProgressHUD;
@import Toast;

@interface TPOSEditWalletViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tokenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLbael;
@property (weak, nonatomic) IBOutlet UITextField *walletField;
@property (weak, nonatomic) IBOutlet UIButton *walletIconButton;

@property (nonatomic, strong) TPOSWalletDao *walletDao;

@property (nonatomic, weak) UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteTopConstraint;

//localized
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *cahngePwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *exportLabel;
@property (weak, nonatomic) IBOutlet UIButton *copyyBtn;


@end

@implementation TPOSEditWalletViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editWallet:) name:kEditWalletNotification object:nil];
    
    self.deleteTopConstraint.constant = kIphone5?56:86;
}

- (void)responseRightButton {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"saving"]];
    weakSelf.walletModel.walletName = weakSelf.walletField.text;
    [weakSelf.walletDao updateWalletWithWalletModel:weakSelf.walletModel complement:^(BOOL success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEditWalletNotification object:weakSelf.walletModel];
        [SVProgressHUD showSuccessWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"save_succ"]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)changeLanguage {
    self.nameLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_name"];
    self.addrLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_addr"];
    self.cahngePwdLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"change_pwd"];
    self.exportLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"export_pk"];
    [self.copyyBtn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"addr_copy"] forState:UIControlStateNormal];
    [self.deleteButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_delete"] forState:UIControlStateNormal];
    [self.backButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_mnem"] forState:UIControlStateNormal];
}

- (void)viewDidReceiveLocalizedNotification {
    [super viewDidReceiveLocalizedNotification];
}

#pragma mark - private method

- (void)loadData {
    _backButton.hidden = _walletModel.isBackup;
}

- (void)setupViews {
    self.tokenValueLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:28];
    self.view.backgroundColor = [UIColor whiteColor];
    self.deleteButton.layer.cornerRadius = 5;
    [self addRightBarButton:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"save"]];
    _walletField.text = _walletModel.walletName;
    _addressLbael.text = _walletModel.address;
    _walletIconButton.layer.cornerRadius = 24;
    _walletIconButton.layer.masksToBounds = YES;
    [_walletIconButton setImage:[UIImage imageNamed:_walletModel.walletIcon] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)addRightBarButton:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn.titleLabel sizeToFit];
    rightBtn.userInteractionEnabled = NO;
    [rightBtn addTarget:self action:@selector(responseRightButton) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        [rightBtn sizeToFit];
    } else {
        rightBtn.frame = CGRectMake(0, 0, 44, 44);
    }
    
    rightBtn.userInteractionEnabled = NO;
    self.rightButton = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)textDidChange:(NSNotification *)note {
   BOOL enabled = !(self.walletField.text.length == 0 || [self.walletField.text isEqualToString:_walletModel.walletName]);
    if (enabled) {
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightButton.userInteractionEnabled = YES;
    } else {
        [self.rightButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        self.rightButton.userInteractionEnabled = NO;
    }
}

- (void)editWallet:(NSNotification *)note {
    TPOSWalletModel *n = (TPOSWalletModel *)note.object;
    if ([_walletModel.walletId isEqualToString:n.walletId]) {
        _walletModel = n;
    }
    self.backButton.hidden = _walletModel.isBackup;
}

- (IBAction)copyAddressAction {
    [[UIPasteboard generalPasteboard] setString:_addressLbael.text];
    [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_to_board"]];
}

- (IBAction)editPasswordAction {
    TPOSEditPasswordViewController *editPasswordViewController = [[TPOSEditPasswordViewController alloc] init];
    editPasswordViewController.walletModel = self.walletModel;
    [self.navigationController pushViewController:editPasswordViewController animated:YES];  
}

- (IBAction)exportPrivateKeyAction {
    __weak typeof(self) weakSelf = self;
    [self alertRequiredPasswordWithSubTilte:nil action:^{
        TPOSExportPrivateKeyNoteView *exportPrivateKeyNoteView = [TPOSExportPrivateKeyNoteView exportPrivateKeyNoteViewWithWalletModel:weakSelf.walletModel];
        [exportPrivateKeyNoteView showWithAnimate:TPOSAlertViewAnimateCenterPop inView:weakSelf.view.window];
    }];
}

- (IBAction)deleteAction {
    __weak typeof(self) weakSelf = self;
    [self alertRequiredPasswordWithSubTilte:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"delete_caution"] action:^{
        weakSelf.deleteButton.userInteractionEnabled = NO;
        [SVProgressHUD showWithStatus:nil];
        [weakSelf.walletDao deleteWalletWithAddress:weakSelf.walletModel.address complement:^(BOOL success) {
            if (success) {
                [TPOSThreadUtils runOnMainThread:^{
                    [SVProgressHUD showSuccessWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"delete_succ"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteWalletNotification object:weakSelf.walletModel];
                    [weakSelf responseLeftButton];
                }];
            } else {
                weakSelf.deleteButton.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"delete_fail"]];
            }
        }];
    }];
}

- (void)alertRequiredPasswordWithSubTilte:(NSString *)subTitle action:(void (^)(void))actionBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_pwd"] message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    __weak typeof(alertController) weakAlertController = alertController;
    [alertController addAction:[UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([[weakAlertController.textFields.firstObject.text tb_md5] isEqualToString:self.walletModel.password]) {
            actionBlock();
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"pwd_error"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)remarkAction {
    __weak typeof(self) weakSelf = self;
    [self alertRequiredPasswordWithSubTilte:nil action:^{
        TPOSCreateMemonicViewController *createPrivateKeyViewController = [[TPOSCreateMemonicViewController alloc] init];
        createPrivateKeyViewController.walletModel = _walletModel;
        createPrivateKeyViewController.privateWords = [[_walletModel.mnemonic tb_encodeStringWithKey:_walletModel.password] componentsSeparatedByString:@" "];
        [weakSelf.navigationController presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:createPrivateKeyViewController] animated:YES completion:nil];
    }];
}

- (void)setWalletModel:(TPOSWalletModel *)walletModel {
    _walletModel = walletModel;
    _walletField.text = walletModel.walletName;
    self.title = walletModel?walletModel.walletName:@"";
}

- (TPOSWalletDao *)walletDao {
    if (!_walletDao) {
        _walletDao = [TPOSWalletDao new];
    }
    return _walletDao;
}

@end
