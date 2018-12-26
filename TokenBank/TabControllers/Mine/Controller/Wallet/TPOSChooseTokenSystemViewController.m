//
//  TPOSChooseTokenSystemViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSChooseTokenSystemViewController.h"
#import "UIColor+Hex.h"
#import "TPOSCommonInfoManager.h"
#import "TPOSBlockChainModel.h"
#import "TPOSChooseTokenSystemCell.h"

@import Masonry;
@import MJRefresh;
@import Toast;

@interface TPOSChooseTokenSystemViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<TPOSBlockChainModel *> *dataList;

@end

@implementation TPOSChooseTokenSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupViews {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"choose_blc_type"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSChooseTokenSystemCell" bundle:nil] forCellReuseIdentifier:@"TPOSChooseTokenSystemCell"];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [self colorfulTableHeaderWithBigSize:NO RefreshingBlock:^{
        [weakSelf loadData];
    }];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[TPOSCommonInfoManager shareInstance] getAllBlockChainInfoWithSuccess:^(NSArray<TPOSBlockChainModel *> *blockChains) {
        weakSelf.dataList = blockChains;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPOSChooseTokenSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TPOSChooseTokenSystemCell" forIndexPath:indexPath];
    [cell updateWithModel:_dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_chooseAction) {
        _chooseAction(_dataList[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
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
