//
//  TPOSImportWalletViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSImportWalletViewController.h"
#import "TPOSMemonicImportWalletViewController.h"
#import "TPOSPrivateKeyImportWalletViewController.h"
#import "TPOSScrollContentView.h"
#import "TPOSScanQRCodeViewController.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSBlockChainModel.h"

@import Masonry;

@interface TPOSImportWalletViewController ()<TPOSPageContentViewDelegate,TPOSSegmentTitleViewDelegate>
@property (nonatomic, strong) TPOSPageContentView *pageContentView;
@property (nonatomic, strong) TPOSSegmentTitleView *titleView;
@property (nonatomic, strong) NSMutableArray *importTypeTitles;
@property (nonatomic, assign) TPOSImportWalletType importTypes;

@property (nonatomic, strong) TPOSMemonicImportWalletViewController *memonicVC;
@property (nonatomic, strong) TPOSPrivateKeyImportWalletViewController *pkVC;
@end

@implementation TPOSImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)setupData {
    
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"import_wallet"];
    
    if ((self.importTypes & TPOSImportWalletTypeMemonic) > 0) {
        [self.importTypeTitles addObject:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"mnemonic"]];
    }
    if ((self.importTypes & TPOSImportWalletTypePrivateKey) > 0) {
        [self.importTypeTitles addObject:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"pri_key"]];
    }
}

- (void)setupSubviews {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    [self.view addSubview:line];
    
    self.titleView = [[TPOSSegmentTitleView alloc]initWithFrame:CGRectZero
                                                       titles:[self importTypeTitles]
                                                     delegate:self
                                                indicatorType:TPOSIndicatorTypeEqualTitle];

    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = [UIColor colorWithHex:0x333333];
    self.titleView.titleSelectColor = [UIColor colorWithHex:0x2890FE];
    self.titleView.indicatorColor = [UIColor colorWithHex:0x2890FE];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:15];
    self.titleView.titleFont = [UIFont systemFontOfSize:15];
    self.titleView.selectIndex = 0;
    [self.view addSubview:_titleView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    
    if ((self.importTypes & TPOSImportWalletTypeMemonic) > 0) {
        _memonicVC = [[TPOSMemonicImportWalletViewController alloc] initWithNibName:@"TPOSMemonicImportWalletViewController" bundle:nil];
        _memonicVC.blockchain = self.blockchain;
        [childVCs addObject:_memonicVC];
        [self addChildViewController:_memonicVC];
    }
    if ((self.importTypes & TPOSImportWalletTypePrivateKey) > 0) {
        _pkVC = [[TPOSPrivateKeyImportWalletViewController alloc] initWithNibName:@"TPOSPrivateKeyImportWalletViewController" bundle:nil];
        _pkVC.blockchain = self.blockchain;
        [childVCs addObject:_pkVC];
        [self addChildViewController:_pkVC];
    }
    
    self.pageContentView = [[TPOSPageContentView alloc]initWithFrame:CGRectMake(0, 45.5, kScreenWidth, CGRectGetHeight(self.view.bounds)-65.5) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];
    
    [self setupNavigationBarItem];
}

- (void)setupNavigationBarItem {
    [self addRightBarButtonImage:[UIImage imageNamed:@"icon_qr_scan"] action:@selector(gotoQRScanner)];
}

- (void)gotoQRScanner {
    __weak typeof(self) weakSelf = self;
    
    TPOSScanQRCodeViewController *scanVC = [[TPOSScanQRCodeViewController alloc] init];
    scanVC.kTPOSScanQRCodeResult = ^(NSString *result) {
        NSInteger index = weakSelf.titleView.selectIndex;
        UIViewController *vc = [weakSelf.pageContentView.childVCs objectAtIndex:index];
        if ([vc isKindOfClass:[TPOSPrivateKeyImportWalletViewController class]]) {
            weakSelf.pkVC.scanResult = result;
        } else if ([vc isKindOfClass:[TPOSMemonicImportWalletViewController class]]) {
            weakSelf.memonicVC.scanResult = result;
        }
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - TPOSPageContentViewDelegate & TPOSSegmentTitleViewDelegate
- (void)TPOSSegmentTitleView:(TPOSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(TPOSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
}

#pragma mark - Getter
- (NSMutableArray *)importTypeTitles {
    if (!_importTypeTitles) {
        _importTypeTitles = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _importTypeTitles;
}

- (void)setBlockchain:(TPOSBlockChainModel *)blockchain {
    _blockchain = blockchain;
    
    if ([blockchain.default_token isEqualToString:@"swt"]) {
        self.importTypes = TPOSImportWalletTypePrivateKey;
    } else {
        self.importTypes = TPOSImportWalletTypeMemonic | TPOSImportWalletTypePrivateKey;
    }
}

@end
