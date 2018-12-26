//
//  TPOSProtocolViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/17.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSProtocolViewController.h"
#import "UIColor+Hex.h"
#import "TPOSGuideViewController.h"
#import "TPOSForceCreateWalletViewController.h"

@import WebKit;
@import Masonry;

@interface TPOSProtocolViewController ()
@property (weak, nonatomic) IBOutlet UIView *webViewContrainer;
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation TPOSProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"service_privacy"];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webViewContrainer);
    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://tokenpocket.skyfromwell.com/terms/index.html"]]];
}

- (IBAction)checkAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        _continueButton.backgroundColor = [UIColor colorWithHex:0x5DB8C6];
        _continueButton.userInteractionEnabled = YES;
    } else {
        _continueButton.backgroundColor = [UIColor colorWithHex:0xd6d6d6];
        _continueButton.userInteractionEnabled = NO;
    }
}

- (IBAction)continueAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"redProtocol"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TPOSGuideViewController *guide = [[TPOSGuideViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    guide.enterButtonAction = ^{
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"showedGuide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        TPOSForceCreateWalletViewController *forceCreateWalletViewController = [[TPOSForceCreateWalletViewController alloc] init];
        [weakSelf.navigationController pushViewController:forceCreateWalletViewController animated:YES];
    };
    [self.navigationController pushViewController:guide animated:YES];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

@end
