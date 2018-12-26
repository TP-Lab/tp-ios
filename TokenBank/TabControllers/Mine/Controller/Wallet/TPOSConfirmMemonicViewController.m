//
//  TPOSConfirmPrivateKeyViewController.m
//  TPOSUIProject
//
//  Created by yf on 07/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSConfirmMemonicViewController.h"
#import "UIColor+Hex.h"
#import "NSString+Size.h"
#import "TPOSContentView.h"
#import "TPOSWalletDao.h"
#import "TPOSWalletModel.h"
#import "TPOSMacro.h"

#define PrivateKeyView_X 15.f
#define PrivateKeyViewWidth kScreenWidth - PrivateKeyView_X*2

#define PrivateKeyView_X_Confirm 5.0f
#define PrivateKeyViewWidth_Confirm kScreenWidth - PrivateKeyView_X_Confirm*2

#define PrivateKeyViewDefaultHeight 120.f

#define KeyContentViewSpace_Y 20

#define KeyConfirmViewSpace_Y 65/2

#define NextButttonSpace_Y 76/2

#define BTN_Width kScreenWidth-PrivateKeyView_X*2

#define BTN_Height 94/2

@interface TPOSConfirmMemonicViewController ()<ContentViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *confirmDescriptionLabel;

@property (strong, nonatomic) TPOSContentView *keyContentView;

@property (strong, nonatomic) TPOSContentView *keyConfirmView;

@property (strong, nonatomic) NSMutableArray *privateKeyArray;

@property (strong, nonatomic) NSMutableArray *randomPrivateKeyArray;

@property (strong, nonatomic) NSMutableArray *selectedPrivateKeyArray;

@property (strong, nonatomic) NSMutableArray *removePrivateKeyArray;

@property (strong, nonatomic) UIButton *nextButton;

//locailized
@property (weak, nonatomic) IBOutlet UILabel *confirmTitle;
@property (weak, nonatomic) IBOutlet UILabel *confirmDesc;

@end

@implementation TPOSConfirmMemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_mnem"];
    
    _randomPrivateKeyArray = [NSMutableArray arrayWithCapacity:0];
    _selectedPrivateKeyArray = [NSMutableArray arrayWithCapacity:0];
    _removePrivateKeyArray = [NSMutableArray arrayWithCapacity:0];
    
    _privateKeyArray = [NSMutableArray arrayWithArray:self.memonicWords];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self generateRandomPrivateKeyArray];

    [self createViewControllerUI];
    
    [self createKeyConfirmView];
}

- (void)changeLanguage {
    self.confirmTitle.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm_mnemonic_title"];
    self.confirmDesc.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm_mnemonic_desc"];
}

#pragma mark - private method
- (void)createViewControllerUI{
    self.confirmDescriptionLabel.textColor = [UIColor colorWithHex:0x808080];
}

- (void)createKeyConfirmView{
    
    _keyConfirmView = [[TPOSContentView alloc] initWithFrame:CGRectMake(PrivateKeyView_X_Confirm, 60, PrivateKeyViewWidth_Confirm, PrivateKeyViewDefaultHeight)];
    _keyConfirmView.wordArray = [_randomPrivateKeyArray mutableCopy];
    _keyConfirmView.viewMode = PrivateKeyConfirmMode;
    CGFloat viewHeight = [_keyConfirmView createPrivateKeyButtonsWithArray:_randomPrivateKeyArray];
    _keyConfirmView.frame = CGRectMake(PrivateKeyView_X, 60, PrivateKeyViewWidth, viewHeight);
    _keyConfirmView.backgroundColor = [UIColor whiteColor];
    _keyConfirmView.delegate = self;
    [self.view addSubview:_keyConfirmView];
    
    [self createKeyContentView:viewHeight];
}

- (void)createKeyContentView:(CGFloat)finialHeight{
    _keyContentView = [[TPOSContentView alloc] initWithFrame:CGRectMake(PrivateKeyView_X, CGRectGetMaxY(self.confirmDescriptionLabel.frame) + KeyContentViewSpace_Y, PrivateKeyViewWidth, finialHeight)];
    _keyContentView.backgroundColor = [UIColor colorWithHex:0xF5F5F9 alpha:1];
    _keyContentView.layer.cornerRadius = 4;
    _keyContentView.layer.masksToBounds = YES;
    _keyContentView.delegate = self;
    [self.view addSubview:_keyContentView];
    
    //根据 _keyContentView 重新调整 _keyConfirmView 的 Y 坐标，就是往下移
    _keyConfirmView.frame = CGRectMake(PrivateKeyView_X_Confirm, CGRectGetMaxY(_keyContentView.frame) + KeyConfirmViewSpace_Y, PrivateKeyViewWidth_Confirm, finialHeight);
    
    //next button
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(PrivateKeyView_X, CGRectGetMaxY(_keyConfirmView.frame) + NextButttonSpace_Y, BTN_Width, BTN_Height);
    [_nextButton setBackgroundColor:[UIColor colorWithHex:0x2890FE  alpha:1.0]];
    [_nextButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"next_step"] forState: UIControlStateNormal];
    _nextButton.layer.cornerRadius = 4.0;
    [_nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
}

#pragma mark - button

- (void)generateRandomPrivateKeyArray{
    NSArray *tempArray = [self getRandomKeyFromArray:_privateKeyArray];
    if (tempArray.count != 0) {
        [self generateRandomPrivateKeyArray];
    }
    
    TPOSLog(@"random array: %@",_randomPrivateKeyArray);
}

- (NSArray *)getRandomKeyFromArray:(NSArray *)keyArray{
    if (keyArray.count <= 0) {
        TPOSLog(@"key array is nil or empty");
        return keyArray;
    }
    NSMutableArray *tempArray = [keyArray mutableCopy];
    NSUInteger index = arc4random() % keyArray.count;
    NSString *keyword = keyArray[index];
    [_randomPrivateKeyArray addObject:keyword];
    [_privateKeyArray removeObjectAtIndex:index];
    return tempArray;
}

- (void)clickNextButton:(UIButton *)sender {
    
    BOOL authenticationPass = NO;
    if (self.memonicWords.count == _selectedPrivateKeyArray.count) {
        for (int i = 0; i < self.memonicWords.count; i++) {
            NSString *originString = [self.memonicWords objectAtIndex:i];
            NSString *selectedString = [_selectedPrivateKeyArray objectAtIndex:i];
            if ([originString isEqualToString:selectedString]) {
                authenticationPass = YES;
            }else{
                authenticationPass = NO;
                break;
            }
        }
    }
    
    NSString *alertTitle = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"confirm_result"];
    NSString *alertMessage = @"";
    if (authenticationPass == NO) {
        alertMessage = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"reconfirm_mnemonic"];
    }else{
        alertMessage = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"backup_succ"];
    }
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"ok"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (authenticationPass) {
            weakSelf.walletModel.backup = YES;
            weakSelf.walletModel.mnemonic = nil;
            [[[TPOSWalletDao alloc] init] updateWalletWithWalletModel:self.walletModel complement:^(BOOL success) {
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBackupWalletNotification object:weakSelf.walletModel];
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ContentViewDelegate method
-(void)didClickConfirmPrivateKeyButton:(TPOSContentView *)selfView andPrivateKeyButton:(UIButton *)button{
    
    if (selfView.viewMode == PrivateKeyConfirmMode) {
        if (button.isSelected) {
            [_selectedPrivateKeyArray addObject:button.currentTitle];
        }else{
            [_selectedPrivateKeyArray removeObject:button.currentTitle];
        }
        
        for (UIButton *button in _keyContentView.subviews) {
            [button removeFromSuperview];
            [_keyContentView resetAllProperty];
        }
        
        [_keyContentView createPrivateKeyButtonsWithArray:_selectedPrivateKeyArray];
        
    }else{
        
    }
}


-(void)didClickContentPrivateKeyButton:(TPOSContentView *)selfView andPrivateKeyButton:(UIButton *)button{
    NSMutableArray *buttonTitles = [NSMutableArray arrayWithArray:_selectedPrivateKeyArray];
    for (NSString *title in buttonTitles) {
        if ([button.currentTitle isEqualToString:title]) {
            [_selectedPrivateKeyArray removeObject:title];
        }
    }
    
    for (UIButton *button in _keyContentView.subviews) {
        [button removeFromSuperview];
        [_keyContentView resetAllProperty];
    }
    
    [_keyContentView createPrivateKeyButtonsWithArray:_selectedPrivateKeyArray];
    
    for (UIButton *tempButton in _keyConfirmView.subviews) {
        if ([tempButton.currentTitle isEqualToString:button.currentTitle]) {
            tempButton.selected = NO;
            [tempButton setBackgroundColor:[UIColor whiteColor]];
            [tempButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        }
    }
}

@end
