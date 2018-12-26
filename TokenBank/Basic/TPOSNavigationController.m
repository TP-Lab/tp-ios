//
//  TPOSNavigationController.m
//  TokenBank
//
//  Created by MarcusWoo on 03/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSNavigationController.h"
#import "UIColor+Hex.h"

@interface TPOSNavigationController ()

@end

@implementation TPOSNavigationController

- (void)loadView {
    [super loadView];
    [self setNavigationBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)setNavigationBarStyle {
    self.navigationBar.barStyle = UIBarStyleBlack;
    UIColor *foregroundColor = [UIColor colorWithHex:0xffffff];
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:foregroundColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"PingFangSC-Medium" size:18], NSFontAttributeName, nil];
    
    [self.navigationBar setTitleTextAttributes:titleTextAttributes];
    self.navigationBar.translucent = NO;
    
    [self.navigationBar setBackgroundColor:[UIColor colorWithHex:0x2890FE]];
    [self.navigationBar setBarTintColor:[UIColor colorWithHex:0x2890FE]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
