//
//  TPOSTransactionRecoderViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/9.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionRecoderViewController.h"
#import "UIColor+Hex.h"
#import "TPOSTransactionRecoderCell.h"
#import "TPOSExchangeWalletVewController.h"
#import "TPOSNavigationController.h"
#import "TPOSTransactionRecoderModel.h"
#import "TPOSContext.h"
#import "TPOSWalletModel.h"
#import "TPOSMacro.h"
#import "TPOSTransactionDetailViewController.h"
#import "TPOSJTManager.h"
#import "TPOSJTPaymentInfo.h"

@import Masonry;
@import Toast;

@interface TPOSTransactionRecoderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) TPOSWalletModel *currentWalletModel;

@property (nonatomic, assign) NSInteger seq;
@property (nonatomic, assign) NSInteger ledger;

@end

@implementation TPOSTransactionRecoderViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initCurrentWallet];
    [self setupSubviews];
    [self setupConstraints];
    [self registerCell];
    [self registerNotifications];
}

- (void)responseRightButton {
    TPOSExchangeWalletVewController *exchangeWalletVewController = [[TPOSExchangeWalletVewController alloc] init];
    exchangeWalletVewController.currentWalletModel = self.currentWalletModel;
    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:exchangeWalletVewController] animated:YES completion:nil];
}

#pragma mark - private method

- (void)_initCurrentWallet {
    _currentWalletModel = [TPOSContext shareInstance].currentWallet;
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    if ([swtcChain isEqualToString:_currentWalletModel.blockChainId]) {
        [[TPOSJTManager shareInstance] requestPaymentHistoryWithAddress:_currentWalletModel.address count:10 currency:nil issuer:nil seq:_seq ledger:_ledger success:^(NSArray<TPOSJTPaymentInfo *> *historys,NSInteger ledger,NSInteger seq) {
            if (!weakSelf.seq) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.dataList removeAllObjects];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            if (historys.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            weakSelf.ledger = ledger;
            weakSelf.seq = seq;
            [weakSelf.dataList addObjectsFromArray:historys];
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            if (!weakSelf.seq) {
                [weakSelf.tableView.mj_header endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"req_exchange_list_fail"]];
        }];
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWallet:) name:kChangeWalletNotification object:nil];
}

- (void)changeWallet:(NSNotification *)note {
    _currentWalletModel = note.object;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupSubviews {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_record"];
    [self.view addSubview:self.tableView];
    [self addRightBarButtonImage:[UIImage imageNamed:@"icon_transaction_exchange_account"] action:@selector(responseRightButton)];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *header = [self colorfulTableHeaderWithBigSize:NO RefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.seq = 0;
        weakSelf.ledger = 0;
        [weakSelf loadData];
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [TPOSCustomMJRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSTransactionRecoderCell" bundle:nil] forCellReuseIdentifier:@"TPOSTransactionRecoderCell"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const mineCellId = @"TPOSTransactionRecoderCell";
    TPOSTransactionRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellId forIndexPath:indexPath];
    [cell updateWithModel:self.dataList[indexPath.row] walletAddress:_currentWalletModel.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TPOSTransactionDetailViewController *transactionDetailViewController = [[TPOSTransactionDetailViewController alloc] init];
    transactionDetailViewController.blockChainId = _currentWalletModel.blockChainId;
    transactionDetailViewController.currentAddress = _currentWalletModel.address;
    id obj = _dataList[indexPath.row];
    if ([obj isKindOfClass:[TPOSTransactionRecoderModel class]]) {
        transactionDetailViewController.transactionRecoderModel = obj;
    } else {
        transactionDetailViewController.payInfo = obj;
    }
    [self.navigationController pushViewController:transactionDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor colorWithHex:0xe8e8e8];
        
    }
    return _tableView;
}

- (NSMutableArray<TPOSTransactionRecoderModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
