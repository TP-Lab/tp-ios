//
//  TPOSEnterAuthViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 13/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSEnterAuthViewController.h"
#import "TPOSAuthPasswordViewController.h"
#import "TPOSAuthID.h"
#import "TPOSMacro.h"

@import Toast;

@interface TPOSEnterAuthViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *authTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *passcodeButton;

@property (strong, nonatomic) NSString *authType;
@property (assign, nonatomic) BOOL firstLoad;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation TPOSEnterAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstLoad = YES;
    [self settingBackgroundView];
    [self settingAuthTypeIcon];
    [self gotoAuth];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (IBAction)onPasswordButtonTapped:(id)sender {
    TPOSAuthPasswordViewController *vc = [[TPOSAuthPasswordViewController alloc] initWithNibName:@"TPOSAuthPasswordViewController" bundle:nil];
    vc.pwdType = kTPOSPasswordTypeEnter;
    vc.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"auth_pwd"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onDeviceAuthButtonTapped:(id)sender {
    [self gotoAuth];
}

- (void)gotoAuth {
    if ([self.authType isEqualToString:kAuthTypePassword]) {
        if (self.firstLoad) {
            self.firstLoad = NO;
            return;
        }
        [self onPasswordButtonTapped:nil];
    } else {
        [self askDeviceBiometricAuth];
    }
}

- (void)askDeviceBiometricAuth {
    __weak typeof(self) weakSelf = self;
    [[TPOSAuthID sharedInstance] tb_showAuthIDWithDescribe:nil BlockState:^(TPOSAuthIDState state, NSError *error) {
        if (state == TPOSAuthIDStateNotSupport) { // 不支持TouchID/FaceID
        } else if(state == TPOSAuthIDStateFail) { // 验证失败
        } else if(state == TPOSAuthIDStateTouchIDLockout || state == TPOSAuthIDStateInputPassword || state == TPOSAuthIDStateSystemCancel || state == TPOSAuthIDStateUserCancel) {   // 多次错误，已被锁定
        } else if (state == TPOSAuthIDStateSuccess) { // TouchID/FaceID验证成功
            [weakSelf authSuccess];
        }
    }];
}

- (void)authSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthEnterAppSuccessNotification
                                                        object:nil];
}

- (void)settingAuthTypeIcon {
    _authType = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthTypeKey];
    if (_authType) {
        NSString *iconname = @"icon_auth_password";
        NSString *title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"touch_pwd"];
        if ([_authType isEqualToString:kAuthTypeTouchId]) {
            iconname = @"icon_touchid";
            title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"touch_touchId"];
        } else if ([_authType isEqualToString:kAuthTypeFaceId]) {
            iconname = @"icon_faceid";
            title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"touch_faceId"];
        } else {
            self.passcodeButton.hidden = YES;
        }
        self.authTypeImage.image = [UIImage imageNamed:iconname];
        self.authTypeLabel.text = title;
    }
}

- (void)settingBackgroundView {
    UIImage *backImage = nil;
    self.topConstraint.constant = 350;
    if (kIphoneX) {
        backImage = [UIImage imageNamed:@"bg_auth_812"];
    } else if (kScreenHeight == 736) {
        backImage = [UIImage imageNamed:@"bg_auth_736"];
    } else if (kScreenHeight == 667) {
        backImage = [UIImage imageNamed:@"bg_auth_667"];
    } else {
        backImage = [UIImage imageNamed:@"bg_auth_568"];
        self.topConstraint.constant = 280;
    }
    self.backgroundImageView.image = backImage;
}

@end
