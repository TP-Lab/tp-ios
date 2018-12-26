//
//  TPOSExchangeWalletVewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSExchangeWalletVewController.h"
#import "UIColor+Hex.h"
#import "UIImage+TPOS.h"
#import "TPOSWalletDao.h"
#import "TPOSWalletModel.h"
#import "TPOSContext.h"
#import "TPOSMacro.h"
#import "TPOSWalletDao.h"

@import Masonry;

@interface TPOSExchangeWalletVewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TPOSWalletDao *walletDao;

@end

@implementation TPOSExchangeWalletVewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupSubviews];
    [self setupConstraints];
}

- (UIButton *)backStyleButton {
    UIButton *btn = [super backStyleButton];
    [btn setImage:[UIImage imageNamed:@"icon_transaction_close"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_transaction_close"] forState:UIControlStateHighlighted];
    return btn;
}

- (void)responseLeftButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [self.walletDao findAllWithComplement:^(NSArray<TPOSWalletModel *> *walletModels) {
        weakSelf.walletModels = walletModels;
        [weakSelf.tableView reloadData];
    }];
}

- (TPOSWalletDao *)walletDao {
    if (!_walletDao) {
        _walletDao = [TPOSWalletDao new];
    }
    return _walletDao;
}

#pragma mark - private method

- (void)setupSubviews {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"switch_account"];
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.walletModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const mineCellId = @"TPOSTransactionRecoderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineCellId];
    }
    cell.textLabel.text = _walletModels[indexPath.row].walletName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_currentWalletModel.walletId isEqualToString:_walletModels[indexPath.row].walletId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (![_currentWalletModel.walletId isEqualToString:_walletModels[indexPath.row].walletId]) {
        _currentWalletModel = _walletModels[indexPath.row];
        [self.walletDao updateCurrentWalletID:_currentWalletModel.walletId complement:nil];
        [[TPOSContext shareInstance] setCurrentWallet:_currentWalletModel];
    }
    [self responseLeftButton];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor colorWithHex:0xE8E8E8];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _tableView;
}

@end
