//
//  TPOSTokenDetailViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTokenDetailViewController.h"
#import "UIColor+Hex.h"
#import "TPOSTransactionRecoderCell.h"
#import "TPOSTransactionViewController.h"
#import "TPOSQRCodeReceiveViewController.h"
#import "TPOSMacro.h"
#import "TPOSTokenModel.h"
#import "TPOSContext.h"
#import "TPOSWalletModel.h"
#import "TPOSTransactionDetailViewController.h"
#import "TPOSTokenHistoryModel.h"
#import "NSDate+TPOS.h"
#import "TPOSWeb3Handler.h"
#import "TPOSJTManager.h"
#import "TPOSJTPaymentInfo.h"
#import "TPOSTransactionRecoderModel.h"

@import Toast;
@import Masonry;

@interface TPOSTokenDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;
//@property (nonatomic, strong) NSArray<TPOSJTPaymentInfo *> *dataList1;
@property (weak, nonatomic) IBOutlet UIView *chartContainer;
@property (weak, nonatomic) IBOutlet UILabel *countPointView;
@property (weak, nonatomic) IBOutlet UILabel *moneyPointView;
@property (weak, nonatomic) IBOutlet UILabel *tokenNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenMoneyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transBtnHeightConstraint;

//国际化
@property (weak, nonatomic) IBOutlet UIButton *transButton;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetLabel;

@end

@implementation TPOSTokenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self registerCell];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)changeLanguage {
    [self.transButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"transaction"] forState:UIControlStateNormal];
    [self.receiveButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"receive"] forState:UIControlStateNormal];
    self.amountLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"amount"];
    self.assetLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"Assets"];
}

- (void)viewDidReceiveLocalizedNotification {
    [super viewDidReceiveLocalizedNotification];
}

#pragma mark - private method

- (void)setupSubviews {
    self.title = _tokenModel.symbol;
    NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_tokenModel.balance];
    self.tokenNumLabel.text = [NSString stringWithFormat:@"%.4f", [balance floatValue]];
    self.tableView.tableFooterView = [UIView new];
    
    self.countPointView.layer.cornerRadius = 5;
    self.countPointView.layer.masksToBounds = YES;
    self.moneyPointView.layer.cornerRadius = 5;
    self.moneyPointView.layer.masksToBounds = YES;
    
    self.transBtnHeightConstraint.constant = kIphoneX?65:45;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [self colorfulTableHeaderWithBigSize:NO RefreshingBlock:^{
        [weakSelf loadData];
    }];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSTransactionRecoderCell" bundle:nil] forCellReuseIdentifier:@"TPOSTransactionRecoderCell"];
}

- (void)loadData {
    
    __weak typeof(self) weakSelf = self;
    if ([swtcChain isEqualToString:_tokenModel.blockchain_id]) {
        [[TPOSJTManager shareInstance] requestPaymentHistoryWithAddress:_tokenModel.address count:20 currency:_tokenModel.bl_symbol issuer:@"" seq:0 ledger:0 success:^(NSArray<TPOSJTPaymentInfo *> *historys,NSInteger ledger,NSInteger seq) {
            weakSelf.dataList = historys;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"req_exchange_list_fail"]];
        }];
    }
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const mineCellId = @"TPOSTransactionRecoderCell";
    TPOSTransactionRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellId forIndexPath:indexPath];
    [cell updateWithModel:_dataList[indexPath.row] walletAddress:_tokenModel.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TPOSTransactionDetailViewController *transactionDetailViewController = [[TPOSTransactionDetailViewController alloc] init];
    transactionDetailViewController.blockChainId = _tokenModel.blockchain_id;
    transactionDetailViewController.currentAddress = _tokenModel.address;
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

- (IBAction)transactionAction {
    TPOSTransactionViewController *vc = [[TPOSTransactionViewController alloc] init];
    vc.currentTokenModel = _tokenModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cashierAction {
    TPOSQRCodeReceiveViewController *codeReceiveViewController = [[TPOSQRCodeReceiveViewController alloc] init];
    codeReceiveViewController.address = _tokenModel.address;
    codeReceiveViewController.tokenType = _tokenModel.symbol;
    codeReceiveViewController.tokenAmount = 0;
    codeReceiveViewController.basicType = [_tokenModel.blockchain_id isEqualToString:ethChain] ? TPOSBasicTokenTypeEtheruem : TPOSBasicTokenTypeJingTum;
    [self.navigationController pushViewController:codeReceiveViewController animated:YES];
}


@end
