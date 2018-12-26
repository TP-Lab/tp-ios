//
//  ViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 31/12/2017.
//  Copyright © 2017 MarcusWoo. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webview];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"web3" ofType:@"html"];
//    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 100, 60);
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(onBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    btn.center = self.view.center;
//    [self.view addSubview:btn];
}

- (void)onBtnTapped {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIWebView *)webview {
//    if (!_webview) {
//        _webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
//        _webview.delegate = self;
//    }
//    return _webview;
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    TPOSLog(@"here is web3.js");
//    [self catchJsLog];
//}
//
//- (void)catchJsLog{
//    if(DEBUG){
//        JSContext *ctx = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        ctx[@"console"][@"log"] = ^(JSValue * msg) {
//            TPOSLog(@"H5  log : %@", msg);
//        };
//        ctx[@"console"][@"warn"] = ^(JSValue * msg) {
//            TPOSLog(@"H5  warn : %@", msg);
//        };
//        ctx[@"console"][@"error"] = ^(JSValue * msg) {
//            TPOSLog(@"H5  error : %@", msg);
//        };
//    }
//}

@end
