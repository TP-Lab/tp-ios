//
//  TPOSAssetChooseWalletView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/31.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAssetChooseWalletView.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSBlockChainModel.h"
#import "TPOSLocalizedHelper.h"
#import "TPOSWalletModel.h"

@interface TPOSAssetChooseWalletView() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIButton *backGroundView;

@property (nonatomic, copy) void (^callBack)(TPOSWalletModel *model,BOOL add,BOOL cancel);

@property (nonatomic, strong) NSArray<TPOSWalletModel *> *dataList;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TPOSAssetChooseWalletView

+ (TPOSAssetChooseWalletView *)showInView:(UIView *)view walletModels:(NSArray<NSArray<TPOSWalletModel *> *> *)walletModels offset:(CGFloat)offset selectWalletModel:(TPOSWalletModel *)walletModel callBack:(void(^)(TPOSWalletModel *model,BOOL add,BOOL cancel))callBack {
    TPOSAssetChooseWalletView *assetChooseWalletView = [[TPOSAssetChooseWalletView alloc] init];
    assetChooseWalletView.callBack = callBack;
    [assetChooseWalletView setWalletModels:walletModels selectWallet:walletModel];
    CGRect f = view.bounds;
    f.origin.y += offset;
    f.size.height -= offset;
    assetChooseWalletView.frame = f;
    CGFloat y = -CGRectGetMaxY(assetChooseWalletView.addButton.frame);
    assetChooseWalletView.tableView.transform = CGAffineTransformMakeTranslation(0, y);
    assetChooseWalletView.addButton.transform = CGAffineTransformMakeTranslation(0, y);
    assetChooseWalletView.backGroundView.alpha = 0;
    [view addSubview:assetChooseWalletView];
    [UIView animateWithDuration:0.3 animations:^{
        assetChooseWalletView.tableView.transform = CGAffineTransformIdentity;
        assetChooseWalletView.addButton.transform = CGAffineTransformIdentity;
        assetChooseWalletView.backGroundView.alpha = 1;
    }];
    return assetChooseWalletView;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backGroundView.frame = self.bounds;
}

- (void)setup {
    self.clipsToBounds = YES;
    [self addSubview:self.backGroundView];
    [self addSubview:self.tableView];
    [self addSubview:self.addButton];
    
    
}

- (void)setWalletModels:(NSArray<NSArray<TPOSWalletModel *> *> *)walletModels selectWallet:(TPOSWalletModel *)walletModel {
    
    __block NSInteger count = 0;
    NSMutableArray *temp = [NSMutableArray array];
    for (TPOSWalletModel *model in walletModels) {
        [temp addObject:model];
        count ++;
        if ([model.walletId isEqualToString:walletModel.walletId]) {
            _currentIndex = count-1;
        }
    }
    _dataList = [temp copy];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, MIN(52.5*(_dataList.count), 52.5*6));
    self.addButton.frame = CGRectMake(0, CGRectGetHeight(_tableView.frame), kScreenWidth, 56);
    [self.tableView reloadData];
}

- (void)hide:(UIButton *)sender {
    if (sender) {
        if (_callBack) {
            _callBack(nil,NO,YES);
        }
    }
    CGFloat y = -CGRectGetMaxY(self.addButton.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.backGroundView.alpha = 0;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, y);
        self.addButton.transform = CGAffineTransformMakeTranslation(0, y);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)close {
    [self hide:self.backGroundView];
}

- (void)addAction {
    CGFloat y = -CGRectGetMaxY(self.addButton.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.backGroundView.alpha = 0;
        self.tableView.transform = CGAffineTransformMakeTranslation(0, y);
        self.addButton.transform = CGAffineTransformMakeTranslation(0, y);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    _callBack(nil,YES,NO);
}

#pragma - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"TPOSAssetPopWindowID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSString *title = [_dataList[indexPath.row].blockChainId isEqualToString:swtcChain] ? @"SWTC" : @"ETH";
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",_dataList[indexPath.row].walletName, title];
    
    if (indexPath.row == _currentIndex) {
        cell.textLabel.textColor = [UIColor colorWithHex:0x2890FE];
    } else {
        cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide:nil];
    if (!_callBack) {
        return;
    }
    _callBack(_dataList[indexPath.row],NO,NO);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithHex:0xE8E8E8];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_wallet"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_main_add_wallet"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 6);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        _addButton = btn;
    }
    return _addButton;
}

- (UIButton *)backGroundView {
    if (!_backGroundView) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [btn addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        _backGroundView = btn;
    }
    return _backGroundView;
}

@end
