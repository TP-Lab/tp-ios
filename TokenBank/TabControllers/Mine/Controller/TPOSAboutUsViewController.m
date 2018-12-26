//
//  TPOSAboutUsViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAboutUsViewController.h"
#import "UIColor+Hex.h"
#import "TPOSAboutUsCell.h"
#import "UIDevice+Utility.h"
#import "TPOSH5ViewController.h"
#import "TPOSGuideViewController.h"

@import Masonry;

@interface TPOSAboutUsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSources;

@property (nonatomic, strong) UILabel *copyrightLable;

@end

@implementation TPOSAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableSources = @[@[@{}],
                        @[@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"term_service"],@"action":@"pushToUseProtocol"},
                          @{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"pri_policy"],@"action":@"pushToProtocol"},
                          @{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"ver_release"],@"action":@"pushToVersionLog"}]
                          ];
    //@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"检测新版"},
    //@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"产品向导",@"action":@"pushToGuide"}
    
    [self setupSubviews];
    [self setupConstraints];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Private

- (void)setupSubviews {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"about"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.copyrightLable];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"TPOSAboutUsCell" bundle:nil] forCellReuseIdentifier:@"TPOSAboutUsCell"];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.copyrightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.centerX.equalTo(self.view);
    }];
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
    if (indexPath.section == 0) {
        TPOSAboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TPOSAboutUsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell changeLanguage];
        return cell;
    } else {
        static NSString *mineCellId = @"mineCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineCellId];
        }
        NSDictionary *dict = self.tableSources[indexPath.section][indexPath.row];
        if (dict) {
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.textLabel.textColor = [UIColor colorWithHex:0x33333];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.tableSources[indexPath.section][indexPath.row];
    NSString *action = info[@"action"];
    if (action.length > 0) {
        SEL selector = NSSelectorFromString(action);
        if (selector && [self respondsToSelector:selector]) {
            [self performSelector:selector withObject:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 202;
    }
    return 54;
}

#pragma mark - push

- (void)pushToUseProtocol {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/terms/index.html";
    h5VC.viewType = kH5ViewTypeTerms;
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"term_service"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

- (void)pushToProtocol {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/privacy/index.html";
    h5VC.viewType = kH5ViewTypePrivacy;
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"pri_policy"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

- (void)pushToVersionLog {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
//    h5VC.urlString = @"http://tokenpocket.skyfromwell.com/release/index.html";
    h5VC.viewType = kH5ViewTypeRelease;
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"ver_release"];
    [self.navigationController pushViewController:h5VC animated:YES];
}

- (void)pushToGuide {
    TPOSGuideViewController *guide = [[TPOSGuideViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    guide.enterButtonAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:guide animated:YES];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 45;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
    }
    return _tableView;
}

- (UILabel *)copyrightLable {
    if (!_copyrightLable) {
        _copyrightLable = [UILabel new];
        _copyrightLable.text = @"Copyright © 2018 Token Pocket \n All right reserved";
        _copyrightLable.font = [UIFont systemFontOfSize:10];
        _copyrightLable.numberOfLines = 2;
        _copyrightLable.textColor = [UIColor colorWithHex:0x808080];
        _copyrightLable.textAlignment = NSTextAlignmentCenter;
    }
    return _copyrightLable;
}

@end
