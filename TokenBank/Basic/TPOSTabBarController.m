//
//  TPOSTabBarController.m
//  TokenBank
//
//  Created by MarcusWoo on 03/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTabBarController.h"
#import "TPOSNavigationController.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"

#import "TPOSAssetViewController.h"
#import "TPOSMineViewController.h"
#import "TPOSMacro.h"

@interface TPOSTabBarController ()
@property (nonatomic, strong) TPOSAssetViewController *assetVC;    //资产
@property (nonatomic, strong) TPOSMineViewController *mineVC;     //我

@property (nonatomic, assign) BOOL tabBarHidden;
@property (nonatomic, strong) NSArray *barTitles;

@end

@implementation TPOSTabBarController

+ (instancetype)currentInstance {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).tabbarController;
}

+ (void)initialize {
    // 通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    norDict[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x8a8a8a];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
    selDict[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x2890FE];
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.barTitles = @[@"Assets",@"Profile"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalizedNotification) name:kLocalizedNotification object:nil];
    
    self.delegate = self;
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = YES;
    
    //资产
    _assetVC = [[TPOSAssetViewController alloc] init];
    [self setUpChildControllerWith:_assetVC
                          norImage:[UIImage imageNamed:@"icon_tab_asset_normal"]
                          selImage:[UIImage imageNamed:@"icon_tab_asset_selected"]
                             title:[[TPOSLocalizedHelper standardHelper] stringWithKey:self.barTitles[0]]
                               tag:0];
    
    /** 我 */
    _mineVC = [[TPOSMineViewController alloc] init];
    [self setUpChildControllerWith:_mineVC
                          norImage:[UIImage imageNamed:@"icon_tab_me_normal"]
                          selImage:[UIImage imageNamed:@"icon_tab_me_selected"]
                             title:[[TPOSLocalizedHelper standardHelper] stringWithKey:self.barTitles[1]]
                               tag:1];
    
}


- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title tag:(NSInteger)tag{
    TPOSNavigationController *nav = [[TPOSNavigationController alloc] initWithRootViewController:childVc];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//图片按照原样渲染
    norImage = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//图片按照原样渲染
    
    childVc.tabBarItem.image = norImage;
    childVc.tabBarItem.selectedImage = selImage;
    childVc.title = title;

    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(-1, 0, 1, 0)];

    childVc.tabBarItem.title = title;
    childVc.tabBarItem.tag = tag;
    
    [self addChildViewController:nav];
}

- (void)setTabBarHidden:(BOOL)tabBarHidden {
    CGFloat animationDuration = 0.3;
    if (self.tabBar.hidden == tabBarHidden) {
        return;
    }
    if (tabBarHidden) {
        [[self class] animationPushDown:self.tabBar duration:animationDuration];
    }else{
        [[self class] animationPushUp:self.tabBar duration:animationDuration];
    }
    _tabBarHidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [_assetVC autoRefreshData];
    }
}

+ (void)animationPushUp:(UIView *)view duration:(CGFloat)duration
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationPushDown:(UIView *)view duration:(CGFloat)duration
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark - Notification
- (void)didReceiveLocalizedNotification {
    
    for (UITabBarItem *barItem in self.tabBar.items) {
        barItem.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:self.barTitles[barItem.tag]];
    }
    
    _assetVC.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:self.barTitles[0]];
    _mineVC.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:self.barTitles[1]];
}

@end
