//
//  TPOSExchangeViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSExchangeViewController.h"
#import "TPOSTransactionEmptyView.h"
#import "UIColor+Hex.h"

@import Masonry;

@interface TPOSExchangeViewController ()
@property (nonatomic, strong) TPOSTransactionEmptyView *emptyView;
@end

@implementation TPOSExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
    [self.view addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidReceiveLocalizedNotification {
    [super viewDidReceiveLocalizedNotification];
    [self.emptyView changeLanguage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (TPOSTransactionEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = (TPOSTransactionEmptyView *)[[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionEmptyView" owner:nil options:nil].firstObject;
    }
    return _emptyView;
}

@end
