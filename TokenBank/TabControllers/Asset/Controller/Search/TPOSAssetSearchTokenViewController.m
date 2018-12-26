//
//  TPOSAssetSearchTokenViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 10/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSAssetSearchTokenViewController.h"
#import "TPOSMacro.h"
#import "UIColor+Hex.h"
#import "TPOSTokenManager.h"
#import "TPOSWalletDetailModel.h"
#import "TPOSAssetCreateWalletView.h"
#import "TPOSTokenModel.h"
#import "TPOSSelectChainTypeViewController.h"
#import "TPOSNavigationController.h"
#import "TPOSCreateWalletViewController.h"

@import Masonry;
@import Toast;

@interface TPOSAssetSearchTokenViewController ()<UITableViewDelegate, UITableViewDataSource, TPOSMarketHotCellDelegate, TPOSMarketSearchCellDelegate, TPOSAssetCreateWalletViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) NSMutableArray *hotList;
@property (nonatomic, weak) UITextField *searchBarTextField;
@end

@implementation TPOSAssetSearchTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBarTextField = [self addNaviSearchBarWithPlaceholder:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"input_asset_name"] width:kScreenWidth - 71];
    
    [self setupSubviews];
    [self setupConstraints];
    
    [self requestHotList];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self registerCells];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    
    __weak typeof(self) weakSelf = self;
    [self addRightBarButton:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"cancel"] operationBlock:^(UIButton *rightBtn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestHotList {
    __weak typeof(self) weakSelf = self;
    [[TPOSTokenManager shareInstance] requestHotTokenList:^(NSArray<TPOSTokenModel *> *hotList) {
        [weakSelf.hotList removeAllObjects];
        [weakSelf.hotList addObjectsFromArray:hotList];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        TPOSLog(@"error:%@",error);
    }];
}

- (void)registerCells {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSMarketSearchCell" bundle:nil] forCellReuseIdentifier:@"TPOSMarketSearchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSMarketHotCell" bundle:nil] forCellReuseIdentifier:@"TPOSMarketHotCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)searchBarTextfieldDidChange:(UITextField *)textfield {
    [super searchBarTextfieldDidChange:textfield];
    if (textfield.text.length > 0) {
        NSString *key = [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        __weak typeof(self) weakSelf = self;
        self.startIndex = 0;
        [[TPOSTokenManager shareInstance] searchTokenWithKey:key start:self.startIndex count:20 success:^(NSArray<TPOSTokenModel *> *tokenList) {
            if (weakSelf.startIndex == 0) {
                [weakSelf.searchList removeAllObjects];
            }
            if (tokenList) {
                [weakSelf.searchList addObjectsFromArray:tokenList];
            }
            if (tokenList.count > 0) {
                weakSelf.startIndex += tokenList.count;
            }
            
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            [weakSelf.view makeToast:error.localizedDescription];
        }];
    } else {
        [self.tableView reloadData];
    }
}

- (void)addSearchToken:(TPOSTokenModel *)token {
    [self.view makeToastActivity:CSToastPositionCenter];
    
    __weak typeof(self) weakSelf = self;
    __block NSString *walletId = nil;
    
    [[TPOSTokenManager shareInstance].addedTokenModels enumerateObjectsUsingBlock:^(NSArray<TPOSWalletDetailModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.firstObject.blockchain_id isEqualToString:token.blockchain_id]) {
            walletId = obj.firstObject.hid;
            *stop = YES;
        }
    }];
    
    if (!walletId) {
        
        if (self.searchBarTextField.isFirstResponder) {
            [self.searchBarTextField resignFirstResponder];
        }
        
        [self.view hideToastActivity];

        TPOSAssetCreateWalletView *walletView = [TPOSAssetCreateWalletView walletViewWithToken:token];
        walletView.delegate = self;
        [walletView showWithAnimate:TPOSAlertViewAnimateBottomUp inView:self.view.window];
        return;
    }
    
    [[TPOSTokenManager shareInstance] addTokenInWalletWithTokenId:token.hid walletId:walletId success:^(NSInteger tokenId) {
        [weakSelf.view hideToastActivity];
        token.added = 1;
        [weakSelf.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddTokenNotification object:token];
        
    } failure:^(NSError *error) {
        [weakSelf.view hideToastActivity];
        [weakSelf.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchBarTextField.text.length > 0) {
        return self.searchList.count;
    } else {
        NSInteger hotCount = self.hotList.count;
        return (hotCount/2 + hotCount%2) + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchBarTextField.text.length > 0) {
        TPOSMarketSearchCell *cell = (TPOSMarketSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"TPOSMarketSearchCell" forIndexPath:indexPath];
        cell.delegate = self;
        TPOSTokenModel *token = [self.searchList objectAtIndex:indexPath.row];
        [cell updateCellWithToken:token];
        return cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
            title.font = [UIFont systemFontOfSize:14];
            title.textColor = [UIColor colorWithHex:0x333333];
            title.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"hot_coin"];
            [cell.contentView addSubview:title];
            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
            return cell;
        } else {
            TPOSMarketHotCell *cell = (TPOSMarketHotCell *)[tableView dequeueReusableCellWithIdentifier:@"TPOSMarketHotCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSInteger index = indexPath.row - 1;
            TPOSTokenModel *left = [self.hotList objectAtIndex:index * 2];
            TPOSTokenModel *right = nil;
            if (self.hotList.count > index * 2 + 1) {
                right = [self.hotList objectAtIndex:index*2+1];
            }
            [cell updateCells:left rightToken:right];
            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchBarTextField.text.length > 0) {
        return 72;
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return 89;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated: self.searchBarTextField.text.length > 0 ? YES : NO];
    
    if (self.searchBarTextField.text.length > 0) {
        [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"coming_soon"] duration:1.0 position:CSToastPositionCenter];
    }
}

#pragma mark - TPOSMarketSearchCellDelegate
- (void)TPOSMarketHotCellDidTapLeftAddButtonWithToken:(TPOSTokenModel *)token {
    [self addSearchToken:token];
}

- (void)TPOSMarketHotCellDidTapRightAddButtonWithToken:(TPOSTokenModel *)token {
    [self addSearchToken:token];
}

#pragma mark - TPOSMarketHotCellDelegate
- (void)TPOSMarketSearchCellDidTapAddButtonWithToken:(TPOSTokenModel *)token {
    [self addSearchToken:token];
}

#pragma mark - TPOSAssetCreateWalletViewDelegate
//导入钱包
- (void)TPOSAssetCreateWalletViewDidTapInjectWithToken:(TPOSTokenModel *)token {
    TPOSSelectChainTypeViewController *selectChainTypeViewController = [[TPOSSelectChainTypeViewController alloc] init];
    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:selectChainTypeViewController] animated:YES completion:nil];
}

//创建钱包
- (void)TPOSAssetCreateWalletViewDidTapCreateWithToken:(TPOSTokenModel *)token {
    TPOSCreateWalletViewController *createWalletViewController = [[TPOSCreateWalletViewController alloc] init];
    createWalletViewController.blockChainModel = token.blockchain;
    [self presentViewController:[[TPOSNavigationController alloc] initWithRootViewController:createWalletViewController] animated:YES completion:nil];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)searchList {
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _searchList;
}

- (NSMutableArray *)hotList {
    if (!_hotList) {
        _hotList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotList;
}


@end
