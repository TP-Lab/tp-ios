//
//  TPOSForceCreateWalletViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/17.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSForceCreateWalletViewController.h"
#import "TPOSCreateWalletViewController.h"
#import "TPOSNavigationController.h"
#import "TPOSMacro.h"
#import "UIColor+Hex.h"
#import "TPOSSelectChainTypeViewController.h"
#import "TPOSH5ViewController.h"
//#import "TPOSConfirmMemonicViewController.h"

@interface TPOSForceCreateWalletViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createWalletButton;
@property (weak, nonatomic) IBOutlet UIButton *importWalletButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

//Localized
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;


@end

@implementation TPOSForceCreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createWalletButton.layer.cornerRadius = 4;
    self.createWalletButton.layer.masksToBounds = YES;
    self.importWalletButton.layer.cornerRadius = 4;
    self.importWalletButton.layer.masksToBounds = YES;
    self.importWalletButton.layer.borderWidth = 1;
    self.importWalletButton.layer.borderColor = [UIColor colorWithHex:0x2890FE].CGColor;
    
    UIImage *backImage = nil;
    if (kIphoneX) {
        backImage = [UIImage imageNamed:@"bg_welcome_812"];
    } else if (kScreenHeight == 736) {
        backImage = [UIImage imageNamed:@"bg_welcome_736"];
    } else if (kScreenHeight == 667) {
        backImage = [UIImage imageNamed:@"bg_welcome_667"];
    } else {
        backImage = [UIImage imageNamed:@"bg_welcome_568"];
    }
    
    self.backgroundImageView.image = backImage;
}

- (void)changeLanguage {
    [self.createWalletButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_wallet"] forState:UIControlStateNormal];
    [self.importWalletButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_wallet"] forState:UIControlStateNormal];
    [self.protocolButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"entry_agree"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [self animation];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)animation {
    self.titleLabel.alpha = 0;
    self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 100);
    self.subTitleLabel.alpha = 0;
    self.subTitleLabel.transform = CGAffineTransformMakeTranslation(0, 100);
    self.createWalletButton.alpha = 0;
    self.createWalletButton.transform = CGAffineTransformMakeTranslation(0, 100);
    self.importWalletButton.alpha = 0;
    self.importWalletButton.transform = CGAffineTransformMakeTranslation(0, 100);
    
    [UIView animateWithDuration:1 animations:^{
        self.titleLabel.alpha = 1;
        self.subTitleLabel.alpha = 1;
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.subTitleLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            self.createWalletButton.alpha = 1;
            self.importWalletButton.alpha = 1;
            self.createWalletButton.transform = CGAffineTransformIdentity;
            self.importWalletButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
}

- (IBAction)createAction {
    TPOSCreateWalletViewController *createWalletViewController = [[TPOSCreateWalletViewController alloc] init];
    createWalletViewController.ignoreBackup = YES;
    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:createWalletViewController] animated:YES completion:nil];
//    TPOSConfirmMemonicViewController *vc = [[TPOSConfirmMemonicViewController alloc] init];
//    vc.memonicWords = @[@"hello",@"private",@"specailist",@"goldten",@"wenney",@"what",@"kitty",@"doge",@"present",@"flower",@"yellow",@"wind"];
//    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (IBAction)importAction {
    TPOSSelectChainTypeViewController *injectWalletViewController = [[TPOSSelectChainTypeViewController alloc] init];
    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:injectWalletViewController] animated:YES completion:nil];
}

- (IBAction)protocolAction {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"usr_agreement"];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/terms/index.html";
    h5VC.viewType = kH5ViewTypeTerms;
    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:h5VC] animated:YES completion:nil];
}

@end
