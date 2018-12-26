//
//  TPOSChooseTokenViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSChooseTokenViewController.h"
#import "TPOSChooseTokenCell.h"
#import "UIColor+Hex.h"
#import "TPOSTokenModel.h"
#import "TPOSWalletDetailDaoManager.h"
#import "TPOSWalletModel.h"
#import "TPOSContext.h"

@import Masonry;

@interface TPOSChooseTokenViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<TPOSTokenModel *> *dataList;

@property (nonatomic, strong) TPOSWalletModel *currentWallet;

@end

@implementation TPOSChooseTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
}

- (void)setupViews {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_token_trans"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSChooseTokenCell" bundle:nil] forCellReuseIdentifier:@"TPOSChooseTokenCell"];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    _currentWallet = [TPOSContext shareInstance].currentWallet;
    if (_currentWallet) {
        NSString *address = _currentWallet.address;
        [[TPOSWalletDetailDaoManager shareInstance] findWalletDetailWithAddress:address completion:^(NSArray<TPOSTokenModel *> *detailModels) {
            weakSelf.dataList = detailModels;
        }];
        [self.tableView reloadData];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPOSChooseTokenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TPOSChooseTokenCell" forIndexPath:indexPath];
    [cell updateWithModel:_dataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectBlock) {
        _selectBlock(_dataList[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor colorWithHex:0xE8E8E8];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

@end
