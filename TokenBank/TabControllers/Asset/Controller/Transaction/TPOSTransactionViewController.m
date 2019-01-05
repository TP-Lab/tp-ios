//
//  TPOSTransactionViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionViewController.h"
#import "TPOSTransactionView.h"
#import "UIColor+Hex.h"
#import "TPOSCameraUtils.h"
#import "TPOSQRCodeResult.h"
#import "TPOSTransactionConfirmView.h"
#import "TPOSWeb3Handler.h"
#import "TPOSContext.h"
#import "TPOSWalletModel.h"
#import "TPOSTokenModel.h"
#import "NSObject+TPOS.h"
#import "TPOSQRResultHandler.h"
#import "TPOSTransactionCell.h"
#import "TPOSMacro.h"
#import "TPOSTransactionGasView.h"
#import "TPOSChooseTokenViewController.h"
#import "TPOSWalletDao.h"
#import "TPOSBlockChainModel.h"
#import "TPOSJTManager.h"
#import "TPOSRecommendGasModel.h"
#import "TPOSJTPayment.h"
#import "TPOSJTPaymentResult.h"
#import "TPOSWalletDetailDaoManager.h"
#import "NSString+TPOS.h"
#import "UIImage+TPOS.h"
#import <jcc_oc_base_lib/JTWalletManager.h>
#import <jcc_oc_base_lib/JccChains.h>

@import SVProgressHUD;
@import Masonry;
@import Toast;

@interface TPOSTransactionViewController () <UITableViewDelegate,UITableViewDataSource,TPOSTransactionCellDelegate,TPOSTransactionConfirmViewDelegate>

@property (nonatomic, strong) TPOSTransactionView *transView;
@property (nonatomic, strong) id gasPrice;
@property (nonatomic, strong) id transValue;
@property (nonatomic, strong) id minerfee;
@property (nonatomic, assign) long highGasPrice;
@property (nonatomic, assign) long highGasAmount;

@property (nonatomic, strong) NSArray<NSMutableDictionary *> *dataList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextButton;

//long long gasLimite, long long gasPrice
@property (nonatomic, assign) long long gasLimite;
@property (nonatomic, assign) long long currentGasPrice;

@property (nonatomic, assign) double gasTokenValue;

@property (nonatomic, strong) TPOSRecommendGasModel *recommendGasModel;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, strong) TPOSWalletModel *currentWallet;

@property (nonatomic, strong) NSArray<TPOSTokenModel *> *tokens;

@end


@implementation TPOSTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCurrentWallet];
    [self setupSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"transaction"];
    
    [self _initData];
    [self requireGasPrice];
}

- (void) loadCurrentWallet {
    _currentWallet = [TPOSContext shareInstance].currentWallet;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    if ([self.navigationController.viewControllers.firstObject isEqual:self]) {
        [self addLeftBarButtonImage:[[UIImage imageNamed:@"icon_guanbi"] tb_imageWithTintColor:[UIColor whiteColor]] action:@selector(dismissSelf)];
    }
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dismissSelf {
    if ([self.navigationController.viewControllers.firstObject isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)checkNextEnable {
    __block NSInteger enable = 0;
    [_dataList enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = obj[@"value"];
        if (idx < 4 && value.length > 0) {
            enable |= (1 << idx);
        }
    }];
    if (enable == 0b1111) {
        if (!self.nextButton.userInteractionEnabled) {
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = [UIColor colorWithHex:0x2890FE];
        }
    } else {
        if (self.nextButton.userInteractionEnabled) {
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.backgroundColor = [UIColor colorWithHex:0xA3CFFF];
        }
    }
}

- (void)loadTokensModel {
    __weak typeof(self) weakSelf = self;
    if (_currentWallet) {
        NSString *address = _currentWallet.address;
        [[TPOSWalletDetailDaoManager shareInstance] findWalletDetailWithAddress:address completion:^(NSArray<TPOSTokenModel *> *detailModels) {
            weakSelf.tokens = detailModels;
        }];
    }
    
}

#pragma mark - Private

- (void)_initData {
    __weak typeof(self) weakSelf = self;
    if (_currentTokenModel) {
        self.dataList[0][@"value"] = _currentTokenModel.symbol;
    } else if (self.qrResult) { //扫码
        if (self.qrResult.iban.length > 0) {
            [[TPOSWeb3Handler sharedManager] changeToAddressWithIban:self.qrResult.iban callBack:^(id responseObject) {
                if (responseObject != nil) {
                    weakSelf.dataList[1][@"value"] = responseObject;
                    [weakSelf.tableView reloadData];
                }
            }];
        } else if (self.qrResult.address.length > 0) {
            self.dataList[1][@"value"] = self.qrResult.address;
        }
        
        weakSelf.dataList[2][@"value"] = self.qrResult.amount.stringValue;
        [weakSelf loadTokensModel];
        [weakSelf.tokens enumerateObjectsUsingBlock:^(TPOSTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.symbol uppercaseString] isEqualToString: [weakSelf.qrResult.token uppercaseString]]) {
                weakSelf.currentTokenModel = obj;
                *stop = YES;
            }
        }];
        if (_currentTokenModel) {
            self.dataList[0][@"value"] = _currentTokenModel.symbol;
        }
        [self.tableView reloadData];
    }
}

- (void)resetTokenValue {
    _dataList[1][@"value"] = nil;
    _dataList[2][@"value"] = nil;
    _dataList[3][@"value"] = nil;
    _dataList[4][@"value"] = nil;
    [self.tableView reloadData];
}

- (void)requireGasPrice {
    __weak typeof(self) weakSelf = self;
    [[TPOSWeb3Handler sharedManager] getGasPriceWithCallBack:^(id responseObject) {
        weakSelf.gasPrice = responseObject;
    }];
    
}

- (void)onRightBarButtonItemTapped {
    __weak typeof(self) weakSelf = self;
    [[TPOSCameraUtils sharedInstance] startScanCameraWithVC:self completion:^(NSString *result) {
        if (result) {
            TPOSQRCodeResult *qrResult = [[TPOSQRResultHandler sharedInstance] codeResultWithScannedString:result];
            [[TPOSWeb3Handler sharedManager] changeToAddressWithIban:qrResult.iban callBack:^(id responseObject) {
                [weakSelf.transView fillToAddress:responseObject];
            }];
        }
    }];
}

- (void)setupSubviews {
    
    //    [self addRightBarButtonImage:[UIImage imageNamed:@"icon_scan"] action:@selector(onRightBarButtonItemTapped)];
    
    [self.tableView registerClass:[TPOSTransactionCell class] forCellReuseIdentifier:[TPOSTransactionCell reuseIdentifier]];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //    self.transView = [[TPOSTransactionView alloc] init];
    //    self.transView.delegate = self;
    //    [self.view addSubview:self.transView];
    //
    //    [self.transView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view);
    //    }];
}


#pragma mark - TPOSTransactionConfirmViewDelegate

- (void)TPOSTransactionConfirmView:(TPOSTransactionConfirmView *)confirmView didConfirmPassword:(NSString *)pswd {
    __weak typeof(self) weakSelf = self;
    if ([_currentWallet.password isEqualToString:[pswd tb_md5]]) {
        NSString *to = weakSelf.dataList[1][@"value"];
        NSString *remark = weakSelf.dataList[4][@"value"];
        if ([swtcChain isEqualToString:_currentTokenModel.blockchain_id]) {
            [SVProgressHUD show];
            TPOSJTPayment *payment = [[TPOSJTPayment alloc] init];
            payment.destination = to;
            payment.source = weakSelf.currentTokenModel.address;
            if (remark) {
                payment.memos = @[remark];
            }
            
            TPOSJTAmount *amount = [[TPOSJTAmount alloc] init];
            amount.value = weakSelf.dataList[2][@"value"];
            NSString *token = weakSelf.currentTokenModel.bl_symbol;
            amount.currency = token;
            amount.issuer = [token isEqualToString:@"SWT"] ? @"" : @"jGa9J9TkqtBcUoHe2zqhVFFbgUVED6o9or";
            payment.amount = amount;
            [[TPOSJTManager shareInstance] startJTPayment:payment secretKey:[_currentWallet.privateKey tb_encodeStringWithKey:_currentWallet.password] fee:[NSString stringWithFormat:@"%.4f",weakSelf.gasTokenValue] success:^(TPOSJTPaymentResult *result) {
                if (result.success) {
                    //                        [SVProgressHUD showSuccessWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_suc"]];
                    [[[UIApplication sharedApplication] keyWindow] makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_suc"] duration:2 position:CSToastPositionCenter];
                    [weakSelf responseLeftButton];
                } else {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@,%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_fail"],result.resultMsg]];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_fai"]];
            }];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"desc_wrong_pwd"]];
    }
}

#pragma mark - event
- (void)chooseTokenAction {
    TPOSChooseTokenViewController *chooseTokenViewController = [[TPOSChooseTokenViewController alloc] init];
    chooseTokenViewController.blockChainId = _currentTokenModel.blockchain_id;
    __weak typeof(self) weakSelf = self;
    chooseTokenViewController.selectBlock = ^(TPOSTokenModel *tokenModel) {
        NSMutableDictionary *data = _dataList[0];
        data[@"value"] = tokenModel.symbol;
        [weakSelf resetTokenValue];
        weakSelf.currentTokenModel = tokenModel;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:chooseTokenViewController animated:YES];
}

- (void)chooseGasAction {
    NSString *token = _dataList[0][@"value"];
    NSString *to = _dataList[1][@"value"];
    NSString *count = _dataList[2][@"value"];
    if (token.length == 0 ) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_token"]];
        return;
    } else if (to.length == 0) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"missing_wallet_addr"]];
        return;
    } else if (count.length == 0 || [count doubleValue] == 0) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"missing_trans_amount"]];
        return;
    }
    
    if (([_currentTokenModel.blockchain_id isEqualToString:ethChain] && [[to uppercaseString] isEqualToString:[_currentTokenModel.address uppercaseString]]) || ([_currentTokenModel.blockchain_id isEqualToString:swtcChain] && [to isEqualToString:_currentTokenModel.address])) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_to_self"]];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    void (^JTAction)(void) = ^{
        TPOSTransactionGasView *transactionGasView = [TPOSTransactionGasView transactionViewWithMinFee:_recommendGasModel.min_gas maxFee:_recommendGasModel.max_gas recommentFee:_recommendGasModel.recommend_gas];
        
        transactionGasView.jtChooseGasPrice = ^(CGFloat gas) {
            NSMutableDictionary *data = _dataList[3];
            weakSelf.gasTokenValue = gas;
            data[@"value"] = [NSString stringWithFormat:@"%.4f%@",gas, @"SWT"];
            [weakSelf checkNextEnable];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [transactionGasView showWithAnimate:TPOSAlertViewAnimateBottomUp inView:self.view.window];
    };
    
    if ([_currentTokenModel.blockchain_id isEqualToString:swtcChain]) { //JT
        [[JTWalletManager shareInstance] isValidAddress:to chain:SWTC_CHAIN completion:^(BOOL isValid) {
            if (!isValid) {
                [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wrong_addr_tips"]];
            } else {
                TPOSRecommendGasModel *model = [TPOSRecommendGasModel new];
                model.max_gas = 1;
                model.min_gas = 0.0001;
                model.recommend_gas = 0.0001;
                model.unit = @"SWT";
                weakSelf.recommendGasModel = model;
                JTAction();
            }
        }];
    }
}

- (void)nextAction {
    
    NSString *count = _dataList[2][@"value"];
    NSString *balance = _currentTokenModel.balance;
    NSString *remark = _dataList[4][@"value"];
    
    __weak typeof(self) weakSelf = self;
    if ([swtcChain isEqualToString:_currentTokenModel.blockchain_id]) {
        weakSelf.remarks = remark;
        if (_currentTokenModel.token_type == 0) {
            if ([balance doubleValue] < [count doubleValue] + _gasTokenValue) {
                [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"no_enough_token"]];
                return;
            }
        } else {
            if ([balance doubleValue] < [count doubleValue]) {  //代币余额不足
                [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"no_enough_token"]];
                return;
            }
        }
        TPOSTransactionConfirmView *transactionConfirmView = [TPOSTransactionConfirmView transactionConfirmView];
        transactionConfirmView.delegate = weakSelf;
        
        [transactionConfirmView fillToLabel:weakSelf.dataList[1][@"value"]];
        [transactionConfirmView fillFromLabel:_currentTokenModel.address];
        [transactionConfirmView fillMinerfee:[NSString stringWithFormat:@"%@",weakSelf.dataList[3][@"value"]]];
        [transactionConfirmView fillGasDescLabel:nil];
        [transactionConfirmView fillMoneyLabel:[NSString stringWithFormat:@"%@%@",weakSelf.dataList[2][@"value"],weakSelf.currentTokenModel.symbol]];
        
        [transactionConfirmView showWithAnimate:TPOSAlertViewAnimateBottomUp inView:weakSelf.view];
    }
}

#pragma mark - TPOSTransactionCellDelegate

- (void)transactionCell:(TPOSTransactionCell *)cell valueChange:(NSString *)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *data = _dataList[indexPath.row];
    data[@"value"] = value;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self checkNextEnable];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPOSTransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:[TPOSTransactionCell reuseIdentifier] forIndexPath:indexPath];
    NSDictionary *data = [self.dataList objectAtIndex:indexPath.row];
    [cell textFieldEnable:[data[@"textFieldEnable"] boolValue]];
    [cell updateWithTitle:data[@"title"] value:data[@"value"]];
    cell.delegate = self;
    if (indexPath.row == 2) {
        cell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (indexPath.row == 1) {
        cell.inputTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    } else {
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    NSString *placeHolder = data[@"placeHolder"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xDDDDDD]}];
    cell.inputTextField.attributedPlaceholder = att;
    NSString *action = data[@"action"];
    cell.accessoryType = action.length > 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [self.dataList objectAtIndex:indexPath.row];
    NSString *action = data[@"action"];
    if (action.length > 0 && [self respondsToSelector:NSSelectorFromString(action)]) {
        [self performSelector:NSSelectorFromString(action)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - get & set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"next_step"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHex:0xA3CFFF];//#A3CFFF 100% 0x2890FE
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.userInteractionEnabled = NO;
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
        [footer addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footer).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
        _nextButton = btn;
        _tableView.tableFooterView = footer;
        _tableView.separatorColor = [UIColor colorWithHex:0xE8E8E8];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (NSArray *)dataList {
    if (!_dataList) {
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:5];
        [dataList addObject:@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"token_trans"],@"value":@"",@"action":@"chooseTokenAction",@"placeHolder":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_token"]}.mutableCopy];
        [dataList addObject:@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_addr"],@"value":@"",@"action":@"",@"textFieldEnable":@YES,@"placeHolder":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_paste_addr"]}.mutableCopy];
        [dataList addObject:@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_amount"],@"value":@"",@"action":@"",@"textFieldEnable":@YES,@"placeHolder":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_out_amount"]}.mutableCopy];
        [dataList addObject:@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"miner_fee"],@"value":@"",@"action":@"chooseGasAction",@"placeHolder":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"select_fee"]}.mutableCopy];
        [dataList addObject:@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"comment"],@"value":@"",@"action":@"",@"textFieldEnable":@YES,@"placeHolder":@""}.mutableCopy];
        _dataList = [dataList copy];
    }
    return _dataList;
}

@end
