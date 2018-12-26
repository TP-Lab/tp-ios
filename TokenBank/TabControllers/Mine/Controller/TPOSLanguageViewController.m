//
//  TPOSLanguageViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 05/03/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSLanguageViewController.h"
#import "TPOSLocalizedHelper.h"
#import "UIColor+Hex.h"

@interface TPOSLanguageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *languages;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *langSymbols;
@end

@import Masonry;

@implementation TPOSLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"language"];
    [self setupData];
    [self setupSubviews];
}

- (void)setupData {
    self.languages = @[@"简体中文",@"繁體中文",@"English"];
    self.langSymbols = @[@"zh-Hans",@"zh-Hant",@"en"];
    
    NSString *curLanguage = [[TPOSLocalizedHelper standardHelper] currentLanguage];
    NSInteger index = [self.langSymbols indexOfObject:curLanguage];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)setupSubviews {
    [self.view addSubview:self.table];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f9];

    __weak typeof(self) weakSelf = self;
    [self addRightBarButton:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"save"]  operationBlock:^(UIButton *rightBtn) {
        [[TPOSLocalizedHelper standardHelper] setUserLanguage:[weakSelf.langSymbols objectAtIndex:weakSelf.selectedIndexPath.row]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.selectedIndexPath.row == indexPath.row) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_language_selected.png"]];
    } else {
        cell.accessoryView = nil;
    }
    
    cell.textLabel.text = [self.languages objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHex:0x323334];
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [tableView reloadData];
}


- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

@end
