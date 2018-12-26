//
//  TPOSH5ViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 11/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSH5ViewController.h"
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
#import "UIColor+Hex.h"
#import "UIImage+TPOS.h"

@interface TPOSH5ViewController ()<WKNavigationDelegate> {
    UIProgressView *_wk_progressView;
}
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation TPOSH5ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _showCloseButton = YES;
    }
    
    return self;
}

- (void)dealloc {
    if (_webView) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        _webView.navigationDelegate = nil;
        [_webView stopLoading];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.titleString) {
        
        
        self.title = self.titleString;
    }
    [self.view setBackgroundColor:[UIColor colorWithHex:0xf5f5f9]];
    
    if (self.navigationController.viewControllers.firstObject == self) {
        [self addLeftBarButtonImage:[[UIImage imageNamed:@"icon_guanbi"] tb_imageWithTintColor:[UIColor whiteColor]] action:@selector(responseLeftButton)];
    }
    
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    
    //添加WK的进度条
    _wk_progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _wk_progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _wk_progressView.tintColor = [UIColor colorWithHex:0x4ED8B5];
    _wk_progressView.trackTintColor = [UIColor clearColor];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.urlString) {
        [self loadURL:self.urlString];
    } else {
        [self loadURL:[self urlStringForType:self.viewType]];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self setNavigationTitleColor:[UIColor whiteColor] barColor:[UIColor colorWithHex:0x2890FE]];
    [self.navigationController.navigationBar addSubview:_wk_progressView];    
}

- (NSString *)urlStringForType:(kH5ViewType)viewType {
    NSString *prefix = @"";
    NSString *suffix = @"";
    switch (viewType) {
        case kH5ViewTypeHelp:
            suffix = @"";
            break;
        case kH5ViewTypePrivacy:
            suffix = @"";
            break;
        case kH5ViewTypeTerms:
            suffix = @"";
            break;
        case kH5ViewTypeRelease:
            suffix = @"";
            break;
        default:
            break;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",prefix,suffix];
    return urlString;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_wk_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;
    //    self.headView.rightBtn.hidden = !_showCloseButton;
}

#pragma mark - Private Methods

- (void)loadURL:(NSString *)urlString {
    if (!urlString || urlString.length == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webView loadRequest:request];
}

#pragma mark - HeadViewDelegate

- (void)responseLeftButton {
    if (!self.webView.canGoBack) {
        [self.webView setNavigationDelegate:nil];
        [self.webView stopLoading];
        if (self.presentingViewController && self.navigationController.viewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.webView goBack];
    }
}

#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    NSString *u = navigationAction.request.URL.absoluteString;
    
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (self.titleString == nil || self.titleString.length == 0) {
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable titleString, NSError * _Nullable error) {
            if (titleString) {
                self.title = titleString;
            }
        }];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (progress == 1) {
            if (!_wk_progressView.isHidden) {
                _wk_progressView.hidden = YES;
                [_wk_progressView setProgress:0 animated:NO];
            }
        } else {
            if (_wk_progressView.isHidden) {
                _wk_progressView.hidden = NO;
            }
            
            [_wk_progressView setProgress:progress animated:YES];
        }
    }
}

@end
