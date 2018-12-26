//
//  TPOSSettingViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSSettingViewController.h"
#import "UIColor+Hex.h"
#import "TPOSAuthPasswordViewController.h"
#import "TPOSLanguageViewController.h"
#import "TPOSAuthID.h"
#import "TPOSMacro.h"

@import Masonry;
@import LocalAuthentication;

@interface TPOSSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSources;

@property (nonatomic, strong) UISwitch *fingerprintLoginSwitch;
@property (nonatomic, strong) NSString *authString;

@end

@implementation TPOSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupData];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void)changeLanguage {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"settings"];
}

#pragma mark - Private

- (void)setupData {
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthTypeKey];
    if (authType) {
        if ([authType isEqualToString:kAuthTypePassword]) {
            _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_pwd"];
        } else if ([authType isEqualToString:kAuthTypeFaceId]) {
            _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_faceid"];
        } else if ([authType isEqualToString:kAuthTypeTouchId]) {
            _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_touchid"];
        }
    } else {
        switch ([TPOSAuthID sharedInstance].supportBiometricType) {
            case TPOSAuthSupportTypeNone:
                _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_pwd"];
                break;
            case TPOSAuthSupportTypeTouchID:
                _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_touchid"];
                break;
            case TPOSAuthSupportTypeFaceID:
                _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_faceid"];
                break;
            default:
                _authString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"login_pwd"];
                break;
        }
    }
    
    BOOL isSwitchOn = ([[NSUserDefaults standardUserDefaults] objectForKey:kAuthSwithOnStatusKey] != nil);
    
    self.tableSources = @[
                          @[@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"language"],@"action":@"pushToLanguageViewController"}],
                          @[@{@"title":_authString,@"switch":@(isSwitchOn)}],
                          ];
    /*
     @{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"货币单位"},
     @{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@""]@"web3设置"}],
     */
}

- (void)setupSubviews {
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"settings"];
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)valueChnage:(UISwitch *)switchView {
    TPOSAuthPasswordViewController *vc = [[TPOSAuthPasswordViewController alloc] initWithNibName:@"TPOSAuthPasswordViewController" bundle:nil];
    
    if (switchView.on) {
        vc.pwdType = kTPOSPasswordTypeSet;
        vc.title = [NSString stringWithFormat:@"%@%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"set"],self.authString];
    } else {
        vc.pwdType = kTPOSPasswordTypeCancel;
        vc.title = [NSString stringWithFormat:@"%@%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"cancel"],self.authString];
    }
    [self.navigationController pushViewController:vc animated:YES];
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
        cell.textLabel.text = [dict objectForKey:@"title"];
        NSNumber *switchValue = dict[@"switch"];
        if (switchValue == nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            UISwitch *fingerprintLoginSwitch = [[UISwitch alloc] init];
            [fingerprintLoginSwitch addTarget:self action:@selector(valueChnage:) forControlEvents:UIControlEventTouchUpInside];
            fingerprintLoginSwitch.on = [switchValue boolValue];
            cell.accessoryView = fingerprintLoginSwitch;
            _fingerprintLoginSwitch = fingerprintLoginSwitch;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 5 : 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.tableSources[indexPath.section][indexPath.row];
    NSString *action = info[@"action"];
    if (action.length > 0) {
        SEL selector = NSSelectorFromString(action);
        [self performSelector:selector withObject:nil];
    }
}


#pragma mark - push

- (void)pushToLanguageViewController {
    TPOSLanguageViewController *vc = [[TPOSLanguageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
