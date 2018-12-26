//
//  TPOSBaseViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"

@import Masonry;
@import MJRefresh;
@import SVProgressHUD;

@interface TPOSBaseViewController ()
@property (nonatomic, copy) void (^rightButtonAction)(UIButton *rightBtn);
@end

@implementation TPOSBaseViewController

- (void)dealloc {
    TPOSLog(@"dealloc %@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self addLeftBarButton:nil];
    }
    
    [self registLocalizedNotification];
    
    [self changeLanguage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //默认显示navigationBar,可在子类中自定义
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD setContainerView:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD setContainerView:self.view];
}

- (MJRefreshGifHeader *)grayTableHeaderWithBigSize:(BOOL)isBigone
                                   RefreshingBlock:(tableHeaderRefreshAction)actionBlock {
    
    MJRefreshGifHeader_TPOS *header = [MJRefreshGifHeader_TPOS headerWithRefreshingBlock:actionBlock];
    header.colorType = MJLoadingGifColorTypeGray;
    
    NSArray *idleImages = @[[UIImage imageNamed:@"icon_loading_pull_gray.png"]];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *refreshingImages = @[].mutableCopy;
    NSString *prefix = [NSString stringWithFormat:@"loading_%@gray",isBigone?@"big":@"small"];
    for (int i = 14; i <= 36; i++) {
        NSString *name = [NSString stringWithFormat:@"%@_%05d.png",prefix,i];
        [refreshingImages addObject:[UIImage imageNamed:name]];
    }
    [header setImages:refreshingImages duration:1.2 forState:MJRefreshStateRefreshing];
    //隐藏时间和状态
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    return header;
}

- (MJRefreshGifHeader *)colorfulTableHeaderWithBigSize:(BOOL)isBigone
                                       RefreshingBlock:(tableHeaderRefreshAction)actionBlock {
    
    MJRefreshGifHeader_TPOS *header = [MJRefreshGifHeader_TPOS headerWithRefreshingBlock:actionBlock];
    header.colorType = MJLoadingGifColorTypeColorful;

    NSArray *idleImages = @[[UIImage imageNamed:@"icon_loading_pull_colorful.png"]];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *refreshingImages = @[].mutableCopy;
    NSString *prefix = [NSString stringWithFormat:@"loading_%@color",isBigone?@"big":@"small"];
    for (int i = 14; i <= 36; i++) {
        NSString *name = [NSString stringWithFormat:@"%@_%05d.png",prefix,i];
        [refreshingImages addObject:[UIImage imageNamed:name]];
    }
    [header setImages:refreshingImages duration:1.2 forState:MJRefreshStateRefreshing];
    //隐藏时间和状态
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    return header;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)responseLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBarButton:(UIBarButtonItem *)barButtonItem {
    if (!barButtonItem) {
        UIButton *button = [self backStyleButton];
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (UIBarButtonItem *)addLeftBarButtonImage:(UIImage *)img action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    
    if (@available(iOS 11.0, *)) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
    } else {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    return item;
}

- (void)setNavigationTitleColor:(UIColor *)textColor barColor:(UIColor *)barColor{
    UIColor *foregroundColor = textColor?textColor:[UIColor whiteColor];
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:foregroundColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:18 weight:UIFontWeightMedium], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
    
    [self.navigationController.navigationBar setBackgroundColor:barColor?barColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:barColor?barColor:[UIColor whiteColor]];
}

- (UIButton *)backStyleButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"icon_navi_back"];
    UIImage *highlightImage = [UIImage imageNamed:@"icon_navi_back"];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    if (@available(iOS 11.0, *)) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -26, 0, 0);
    } else {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    }
    
    if ([self respondsToSelector:@selector(responseLeftButton)]) {
        [button addTarget:self action:@selector(responseLeftButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    button.frame = CGRectMake(0, 0, 44, 44);
    return button;
}

- (void)addLeftBarButton:(NSString *)title operationBlock:(void (^)(UIButton *rightBtn))operationBlock {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn.titleLabel sizeToFit];
    if (operationBlock) {
        operationBlock(rightBtn);
    }
    if (@available(iOS 11.0, *)) {
        [rightBtn sizeToFit];
    } else {
        rightBtn.frame = CGRectMake(0, 0, 44, 44);
    }
    
    [rightBtn addTarget:self action:@selector(responseLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)addRightBarButton:(NSString *)title operationBlock:(void (^)(UIButton *rightBtn))operationBlock {
    [self addRightBarButton:title action:@selector(responseRightButton) operationBlock:operationBlock];
}

- (void)addRightBarButton:(NSString *)title action:(SEL)action operationBlock:(void (^)(UIButton *rightBtn))operationBlock {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtn.titleLabel sizeToFit];
    [rightBtn addTarget:self action:@selector(responseRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.rightButtonAction = operationBlock;
    if (@available(iOS 11.0, *)) {
        [rightBtn sizeToFit];
    } else {
        rightBtn.frame = CGRectMake(0, 0, 44, 44);
    }
    
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (UIBarButtonItem *)addRightBarButtonImage:(UIImage *)img action:(SEL)action {
    return [self addRightBarButtonImage:img highlightImage:nil action:action];
}

- (UIBarButtonItem *)addRightBarButtonImage:(UIImage *)image highlightImage:(UIImage *)himage action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    if (himage) {
        [button setImage:himage forState:UIControlStateHighlighted];
    }
    button.frame = CGRectMake(0, 0, 44, 44);
    
    if (@available(iOS 11.0, *)) {
        if (image) {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 12 + image.size.width/2.0, 0, 0);
        }
    }
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    return item;
}

- (void)responseRightButton {
    if (self.rightButtonAction) {
        self.rightButtonAction(nil);
    }
}

- (UITextField *)addNaviSearchBarWithPlaceholder:(NSString *)placeholder width:(CGFloat)width {
    
    UIView *searchBar = [[UIView alloc] initWithFrame:CGRectMake(5, 7, width, 30)];
    searchBar.backgroundColor = [UIColor clearColor];
    
    UIView *barContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width - 20, 30)];
    barContainer.backgroundColor = [UIColor colorWithHex:0xffffff];
    barContainer.layer.cornerRadius = 4;
    barContainer.layer.masksToBounds = YES;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 14, 14)];
    searchIcon.image = [UIImage imageNamed:@"icon_searchbar.png"];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(27, 4.5, width - 52, 21)];
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = placeholder;
    textField.tintColor= [UIColor lightGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(searchBarTextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [barContainer addSubview:searchIcon];
    [barContainer addSubview:textField];
    [searchBar addSubview:barContainer];
    
    self.navigationItem.titleView = searchBar;
    
    return textField;
}

- (void)searchBarTextfieldDidChange:(UITextField *)textfield {
}


//国际化
- (void)registLocalizedNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidReceiveLocalizedNotification)
                                                 name:kLocalizedNotification
                                               object:nil];
}

- (void)viewDidReceiveLocalizedNotification {
    [self changeLanguage];
}
- (void)changeLanguage {}

@end
