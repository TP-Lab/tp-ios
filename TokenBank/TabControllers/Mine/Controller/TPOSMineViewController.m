//
//  TPOSMineViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 06/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSMineViewController.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import <Masonry/Masonry.h>
#import "TPOSSettingViewController.h"
#import "TPOSAboutUsViewController.h"
#import "TPOSWalletManagerViewController.h"
#import "TPOSTransactionRecoderViewController.h"
#import "TPOSH5ViewController.h"

@interface TPOSMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *tableSources;
@end

@implementation TPOSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    
    [self setupData];
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarColor];
}

- (void)changeLanguage {
    [self setupData];
    [self.table reloadData];
}

- (void)viewDidReceiveLocalizedNotification {
    [super viewDidReceiveLocalizedNotification];
}


#pragma mark - Private

- (void)setupData {
    self.tableSources = @[@[],
                          @[@{@"icon":@"icon_mine_wallet",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wallet_manage"],@"action":@"pushToWalletManager"},
                            @{@"icon":@"icon_mine_transaction",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_record"],@"action":@"pushToTransactionRecoder"}],
                          @[@{@"icon":@"icon_mine_help",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"help"],@"action":@"pushToHelp"},
                            @{@"icon":@"icon_mine_about",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"about"],@"action":@"pushToAboutUs"},
                            @{@"icon":@"icon_mine_setting",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"settings"],@"action":@"pushToSetting"}]
                          ];
}

- (void)setupSubviews {
    [self.view addSubview:self.table];
}

- (void)setupConstraints {
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setNavigationBarColor {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *infos = self.tableSources[section];
    if (infos) {
        return infos.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const mineCellId = @"mineCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineCellId];
    }
    NSDictionary *dict = self.tableSources[indexPath.section][indexPath.row];
    if (dict) {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorWithHex:0x323334];
        cell.textLabel.text = [dict objectForKey:@"title"];
        cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"icon"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 12)];
    view.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.tableSources[indexPath.section][indexPath.row];
    NSString *action = info[@"action"];
    if (action) {
        SEL selector = NSSelectorFromString(action);
        [self performSelector:selector withObject:nil];
    }
}
#pragma mark - push

- (void)pushToTransactionRecoder {
    TPOSTransactionRecoderViewController *transactionRecoderViewController = [[TPOSTransactionRecoderViewController alloc] init];
    [self.navigationController pushViewController:transactionRecoderViewController animated:YES];
}

- (void)pushToWalletManager {
    TPOSWalletManagerViewController *walletManagerViewController = [[TPOSWalletManagerViewController alloc] init];
    [self.navigationController pushViewController:walletManagerViewController animated:YES];
}

- (void)pushToSetting {
    TPOSSettingViewController *settingViewController = [[TPOSSettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)pushToAboutUs {
    TPOSAboutUsViewController *aboutUsViewController = [[TPOSAboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
}

- (void)pushToHelp {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/help/index.html";
    h5VC.viewType = kH5ViewTypeHelp;
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"help"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

#pragma mark - Getter & Setter
- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        _table.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
        _table.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return _table;
}

@end
