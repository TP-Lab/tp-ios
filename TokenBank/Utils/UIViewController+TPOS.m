//
//  UIViewController+TPOS.m
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "UIViewController+TPOS.h"

@implementation UIViewController (TPOS)

+ (UIViewController *)tb_rootViewController {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    
    if (appWindow) {
        return appWindow.rootViewController;
    }
    
    return nil;
}

+ (instancetype)_topPresentedViewControllerIgnoringNavi:(BOOL)ignoringNavi {
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;

    if (appWindow) {
        UIViewController *topPresented = appWindow.rootViewController;
        
        while (topPresented.presentedViewController)
            topPresented = topPresented.presentedViewController;
        
        if (ignoringNavi && [topPresented isKindOfClass:[UINavigationController class]]) {
            return [(UINavigationController *)topPresented topViewController];
        }
        
        return topPresented;
    }
    
    return nil;
}

+ (instancetype)tb_topPresentedViewController {
    return [self _topPresentedViewControllerIgnoringNavi:NO];
}

+ (instancetype)tb_topPresentedViewControllerIgnoringNavi {
    return [self _topPresentedViewControllerIgnoringNavi:YES];
}

@end
