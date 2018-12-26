//
//  TPOSAuthPasswordViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 13/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAuthPasswordViewController.h"
#import "UIColor+Hex.h"
#import "NSString+TPOS.h"
#import "TPOSMacro.h"
#import "TPOSAuthID.h"
#import "UIImage+TPOS.h"

@import LocalAuthentication;
@import IQKeyboardManager;
@import Toast;

@interface TPOSAuthPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *pwd1;
@property (weak, nonatomic) IBOutlet UITextField *pwd2;
@property (weak, nonatomic) IBOutlet UITextField *pwd3;
@property (weak, nonatomic) IBOutlet UITextField *pwd4;
@property (weak, nonatomic) IBOutlet UITextField *pwd5;
@property (weak, nonatomic) IBOutlet UITextField *pwd6;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *passcodeBg;

@property (weak, nonatomic) IBOutlet UIView *reAuthBg;
@property (weak, nonatomic) IBOutlet UIImageView *reAuthImageView;

@property (nonatomic, assign) TPOSAuthSupportType authType;
@property (nonatomic, strong) NSArray *pwds;
@property (nonatomic, strong) NSMutableString *pwdString;
@property (nonatomic, assign) BOOL wasKeyboardManagerEnabled;
@property (nonatomic, strong) NSString *tipString;
//localized
@property (weak, nonatomic) IBOutlet UILabel *tapToReAuthLabel;

@end

@implementation TPOSAuthPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passcodeBg.layer.borderWidth = 1;
    self.passcodeBg.layer.cornerRadius = 3;
    self.passcodeBg.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
    self.passcodeBg.layer.masksToBounds = YES;
    
    [self.nextButton setBackgroundImage:[UIImage tb_imageWithColor:[UIColor colorWithHex:0x2890FE] andSize:CGSizeMake(150, 45)] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage tb_imageWithColor:[UIColor colorWithHex:0x2890FE alpha:0.4] andSize:CGSizeMake(150, 45)] forState:UIControlStateDisabled];
    self.nextButton.layer.cornerRadius = 3;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.enabled = NO;
    self.nextButton.hidden = self.pwdType != kTPOSPasswordTypeSet;
    
    self.reAuthBg.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    [self.pwd1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwd2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwd3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwd4 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwd5 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwd6 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwd1 becomeFirstResponder];
    
    self.pwds = @[self.pwd1,self.pwd2,self.pwd3,self.pwd4,self.pwd5,self.pwd6];
    
    if (self.pwdType == kTPOSPasswordTypeSet) {
        _tipString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"set_pwd"];
    } else if (self.pwdType == kTPOSPasswordTypeReconfirm) {
        _tipString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"repeat_pwd"];
    } else if (self.pwdType == kTPOSPasswordTypeEnter) {
        _tipString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_pwd_auth"];
    } else if (self.pwdType == kTPOSPasswordTypeCancel) {
        _tipString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_pwd_auth"];
    }
    self.tipLabel.text = _tipString;
    
    _authType = [[TPOSAuthID sharedInstance] supportBiometricType];
    if (_authType != TPOSAuthSupportTypeNone) {
        BOOL isTouchID = _authType==TPOSAuthSupportTypeTouchID;
        self.reAuthImageView.image = [UIImage imageNamed:isTouchID?@"icon_touchid":@"icon_faceid"];
    }
}

- (void)changeLanguage {
    self.tapToReAuthLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"tap_reauth"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)checkButtonsStatus {
    BOOL enable = YES;
    if (self.pwd1.text.length != 1) {   enable = NO;    }
    if (self.pwd2.text.length != 1) {   enable = NO;    }
    if (self.pwd3.text.length != 1) {   enable = NO;    }
    if (self.pwd4.text.length != 1) {   enable = NO;    }
    if (self.pwd5.text.length != 1) {   enable = NO;    }
    if (self.pwd6.text.length != 1) {   enable = NO;    }
    self.nextButton.enabled = enable;
    
    self.reAuthBg.userInteractionEnabled = enable;
    self.reAuthImageView.alpha = enable?1.0:0.5;
}

- (void)textFieldDidChange:(UITextField *)textfield {
    
    if (![self.tipLabel.text isEqualToString:self.tipString]) {
        self.tipLabel.text = self.tipString;
        self.tipLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    
    if (textfield.text.length >= 1) {
        if (textfield.text.length == 2) {
            textfield.text = [textfield.text substringWithRange:NSMakeRange(1, 1)];
        } else {
            textfield.text = [textfield.text substringToIndex:1];
        }
    }
    
    [self checkButtonsStatus];
    
    NSInteger index = [self.pwds indexOfObject:textfield];
    switch (index) {
        case 0:
            [self.pwd2 becomeFirstResponder];
            break;
        case 1:
            [self.pwd3 becomeFirstResponder];
            break;
        case 2:
            [self.pwd4 becomeFirstResponder];
            break;
        case 3:
            [self.pwd5 becomeFirstResponder];
            break;
        case 4:
            [self.pwd6 becomeFirstResponder];
            break;
        case 5: {
            if (self.pwd1.text.length == 0) {
                [self.pwd1 becomeFirstResponder];
                break;
            }
            if (self.pwd2.text.length == 0) {
                [self.pwd2 becomeFirstResponder];
                break;
            }
            if (self.pwd3.text.length == 0) {
                [self.pwd3 becomeFirstResponder];
                break;
            }
            if (self.pwd4.text.length == 0) {
                [self.pwd4 becomeFirstResponder];
                break;
            }
            if (self.pwd5.text.length == 0) {
                [self.pwd5 becomeFirstResponder];
                break;
            }
            self.pwdString = @"".mutableCopy;
            for (UITextField *tf in self.pwds) {
                [self.pwdString appendString:tf.text];
            }
            
            [self.pwd6 resignFirstResponder];
            [self passwordFilledAction];
        }
            break;
            
        default:
            break;
    }
}

- (void)passwordFilledAction {
    switch (self.pwdType) {
        case kTPOSPasswordTypeSet: {
            TPOSAuthPasswordViewController *vc = [[TPOSAuthPasswordViewController alloc] initWithNibName:@"TPOSAuthPasswordViewController" bundle:nil];
            vc.prePassword = self.pwdString;
            vc.pwdType = kTPOSPasswordTypeReconfirm;
            vc.title = self.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kTPOSPasswordTypeReconfirm:
            if ([self.prePassword isEqualToString:self.pwdString]) {
                NSString *encodedPwd = [self.pwdString tb_md5];
                if (encodedPwd) {
                    if (self.authType != TPOSAuthSupportTypeNone) {
                        [self deviceConfirmAction];
                    } else {
                        [self authSuccess];
                    }
                } else {
                    [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"contact_us"] duration:1.0 position:CSToastPositionCenter];
                }
            } else {
                self.tipLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wrong_pwd"];
                self.tipLabel.textColor = [UIColor redColor];
                for (UITextField *tf in self.pwds) {
                    tf.text = @"";
                }
                [self.pwd1 becomeFirstResponder];
            }
            break;
        case kTPOSPasswordTypeEnter: {
            NSString *encodedPwd = [self.pwdString tb_md5];
            NSString *md5Pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthPasswordKey];
            if (![encodedPwd isEqualToString:md5Pwd]) {
                self.tipLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wrong_pwd"];
                self.tipLabel.textColor = [UIColor redColor];
                for (UITextField *tf in self.pwds) {
                    tf.text = @"";
                }
                [self.pwd1 becomeFirstResponder];
            } else {
                [self notiToMain];
            }
        }
            break;
        case kTPOSPasswordTypeCancel: {
            NSString *encodedPwd = [self.pwdString tb_md5];
            NSString *md5Pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthPasswordKey];
            if (![encodedPwd isEqualToString:md5Pwd]) {
                self.tipLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"wrong_pwd"];
                self.tipLabel.textColor = [UIColor redColor];
                for (UITextField *tf in self.pwds) {
                    tf.text = @"";
                }
                [self.pwd1 becomeFirstResponder];
            } else {
                [self cancelPassword];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)notiToMain {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthEnterAppSuccessNotification object:nil];
}

//使用设备验证（Touch ID, Face ID）
- (void)deviceConfirmAction {
    __weak typeof(self) weakSelf = self;
    [[TPOSAuthID sharedInstance] tb_showAuthIDWithDescribe:nil BlockState:^(TPOSAuthIDState state, NSError *error) {
        if (state == TPOSAuthIDStateNotSupport) { // 不支持TouchID/FaceID
//            TPOSLog([[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"对不起，当前设备不支持指纹/面部ID");
        } else if(state == TPOSAuthIDStateFail) { // 验证失败
//            TPOSLog([[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"指纹/面部ID不正确，验证失败");
            [weakSelf.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"auth_failed"] duration:0.8 position:CSToastPositionBottom];
        } else if(state == TPOSAuthIDStateTouchIDLockout || state == TPOSAuthIDStateInputPassword || state == TPOSAuthIDStateSystemCancel || state == TPOSAuthIDStateUserCancel) {   // 多次错误，已被锁定
//            TPOSLog([[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"多次错误，指纹/面部ID已被锁定，请到手机解锁界面输入密码");
            if (weakSelf.pwdType == kTPOSPasswordTypeReconfirm) {
                weakSelf.reAuthBg.hidden = NO;
                [weakSelf checkButtonsStatus];
            }
        } else if (state == TPOSAuthIDStateSuccess) { // TouchID/FaceID验证成功
            [weakSelf authSuccess];
        }
    }];
}

- (void)authSuccess {
    
    NSString *encodedPwd = [self.pwdString tb_md5];
    if (encodedPwd) {
        [[NSUserDefaults standardUserDefaults] setObject:encodedPwd forKey:kAuthPasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"setting_succ"] duration:0.2
                position:CSToastPositionCenter title:nil
                   image:nil
                   style:[[CSToastStyle alloc] initWithDefaultStyle] completion:^(BOOL didTap) {
                       if (weakSelf.authType != TPOSAuthSupportTypeNone) {
                           if (kIphoneX) {
                               [[NSUserDefaults standardUserDefaults] setObject:kAuthTypeFaceId forKey:kAuthTypeKey];
                           } else {
                               [[NSUserDefaults standardUserDefaults] setObject:kAuthTypeTouchId forKey:kAuthTypeKey];
                           }
                       } else {
                           [[NSUserDefaults standardUserDefaults] setObject:kAuthTypePassword forKey:kAuthTypeKey];
                       }
                       
                       [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kAuthSwithOnStatusKey];
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       
                       if (weakSelf.navigationController.viewControllers.count > 1) {
                           UIViewController *destVC = [weakSelf.navigationController.viewControllers objectAtIndex:1];
                           [weakSelf.navigationController popToViewController:destVC animated:YES];
                       }
                   }];
}

- (void)cancelPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAuthSwithOnStatusKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAuthPasswordKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAuthTypeKey];
}

- (IBAction)onNextButtonTapped:(id)sender {
    self.pwdString = @"".mutableCopy;
    for (UITextField *tf in self.pwds) {
        [self.pwdString appendString:tf.text];
    }
    
    [self.pwds makeObjectsPerformSelector:@selector(resignFirstResponder)];
    [self passwordFilledAction];
}

- (IBAction)onReauthButtonTapped:(id)sender {
    [self deviceConfirmAction];
}


@end
