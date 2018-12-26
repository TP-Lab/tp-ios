//
//  TPOSGuideViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSGuideViewController.h"
#import "TPOSMacro.h"
#import "TPOSGuideCCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface TPOSGuideViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray<TPOSGuideModel *> *dataList;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterButton;
@end

@implementation TPOSGuideViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self registerCell];
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - private method
- (void)setupData {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:5];
    NSArray *titleList = @[@"自我掌控资产",@"点对点自由转账",@"DApps 浏览器",@"轻松交易资产",@"欢迎来到新世界"];
    NSArray *subTitleList = @[@"区块链钱包，赋予人人的权力\n私钥即资产，请做好双重备份",@"无需第三方中介\n地球两端，瞬间完成",@"集成智能合约交互\n体验下一代互联网应用",@"内置交易市场\n随时随地查看行情，完成交易",@"必不可少的，前往帮助中心\n学习掌握新世界技能"];
    for (int i = 0; i < 5; i++) {
        TPOSGuideModel *guideModel = [TPOSGuideModel new];
        guideModel.giftImageName = [NSString stringWithFormat:@"tb_images_guide_s%i_gif.gif",i];
        guideModel.normalImageName = [NSString stringWithFormat:@"tb_images_guide_s%i",i];
        guideModel.title = titleList[i];
        guideModel.subTitle = subTitleList[i];
        [dataList addObject:guideModel];
    }
    _dataList = [dataList copy];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.enterButton];
    self.collectionView.pagingEnabled = YES;
}

- (void)registerCell {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TPOSGuideCCell" bundle:nil] forCellWithReuseIdentifier:@"TPOSGuideCCell"];
}

- (void)setupConstraints {
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.height.equalTo(@15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@160);
        make.height.equalTo(@24);
        make.centerX.equalTo(self.pageControl.mas_centerX);
        make.centerY.equalTo(self.pageControl.mas_centerY);
    }];
}

- (void)onEnterButtonTapped {
    if (self.enterButtonAction) {
        self.enterButtonAction();
    }
}

#pragma mark -
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPOSGuideCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPOSGuideCCell" forIndexPath:indexPath];
    [cell updateWithGuideModel:_dataList[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, kScreenHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(TPOSGuideCCell *)cell startPlayGif];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(TPOSGuideCCell *)cell stopPlayGif];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = floor(scrollView.contentOffset.x / kScreenWidth);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x / kScreenWidth;
    TPOSLog(@"cuurentX:%f",currentX);
    if (currentX > 3.0) {
        CGFloat rate = MIN((currentX - 3.0), 1.0);
        self.pageControl.alpha = 1.0 - rate;
        self.enterButton.alpha = rate;
    } else {
        self.pageControl.alpha = 1.0;
        self.enterButton.alpha = 0;
    }
}

#pragma mark - getter
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = 5;
        pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0x606D7B];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x5DB8C6];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *enterTitle = @"进入Token Pocket";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:enterTitle];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold] range:NSMakeRange(0, enterTitle.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x449BAB] range:NSMakeRange(0, enterTitle.length)];
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2, 13, 13);
        attach.image = [UIImage imageNamed:@"icon_guide_arrow.png"];
        NSAttributedString *attachAtt = [NSAttributedString attributedStringWithAttachment:attach];
        [attr appendAttributedString:attachAtt];
        
        [_enterButton setAttributedTitle:attr forState:UIControlStateNormal];
        _enterButton.alpha = 0;
        
        [_enterButton addTarget:self action:@selector(onEnterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

@end
