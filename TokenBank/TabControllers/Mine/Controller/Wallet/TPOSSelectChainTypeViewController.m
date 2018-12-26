//
//  TPOSSelectChainTypeViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSSelectChainTypeViewController.h"
#import "TPOSCommonInfoManager.h"
#import "TPOSWalletChainCell.h"
#import "TPOSBlockChainModel.h"
#import "TPOSImportWalletViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+TPOS.h"

@import Masonry;
@import Toast;

@interface TPOSSelectChainTypeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *chainTable;
@property (nonatomic, strong) NSArray *chains;
@end

@implementation TPOSSelectChainTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_blc_type"];
    [self setupSubviews];
    [self setupConstraints];
    [self setupData];
}

- (void)loadData {
    TPOSCommonInfoManager *commonInfoManager = [TPOSCommonInfoManager shareInstance];
    __weak typeof(commonInfoManager) weakCommonInfoManager = commonInfoManager;
    __weak typeof(self) weakSelf = self;
    [commonInfoManager getAllBlockChainInfoWithSuccess:^(NSArray<TPOSBlockChainModel *> *blockChains) {
        [weakCommonInfoManager storeAllBlockchainInfos:blockChains];
        weakSelf.chains = blockChains;
        [weakSelf.chainTable.mj_header endRefreshing];
        [weakSelf.chainTable reloadData];
    } fail:^(NSError *error) {
        [weakSelf.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"chain_info_retry"] duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)setupData {
    if ([TPOSCommonInfoManager shareInstance].allBlockchains) {
        self.chains = [NSArray arrayWithArray:[TPOSCommonInfoManager shareInstance].allBlockchains];
        [self.chainTable reloadData];
    } else {
        [self loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private
- (void)setupSubviews {
    if (self.navigationController.viewControllers.firstObject == self) {
        [self addLeftBarButtonImage:[[UIImage imageNamed:@"icon_guanbi"] tb_imageWithTintColor:[UIColor whiteColor]] action:@selector(responseLeftButton)];
    }
    [self.view addSubview:self.chainTable];
    [self.chainTable registerNib:[UINib nibWithNibName:@"TPOSWalletChainCell" bundle:nil] forCellReuseIdentifier:@"TPOSWalletChainCell"];
    
    __weak typeof(self) weakSelf = self;
    self.chainTable.mj_header = [self colorfulTableHeaderWithBigSize:NO RefreshingBlock:^{
        [weakSelf loadData];
    }];
}

- (void)setupConstraints {
    [self.chainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chains.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPOSWalletChainCell *cell = (TPOSWalletChainCell *)[tableView dequeueReusableCellWithIdentifier:@"TPOSWalletChainCell" forIndexPath:indexPath];
    [cell updateWithChainModel:self.chains[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TPOSBlockChainModel *chain = [self.chains objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    TPOSImportWalletViewController *vc = [[TPOSImportWalletViewController alloc] init];
    vc.blockchain = chain;
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter & Getter
- (UITableView *)chainTable {
    if (!_chainTable) {
        _chainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _chainTable.delegate = self;
        _chainTable.dataSource = self;
        _chainTable.tableFooterView = [UIView new];
        _chainTable.separatorInset = UIEdgeInsetsZero;
    }
    return _chainTable;
}

@end
