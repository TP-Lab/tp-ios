//
//  UIViewController+TPOS.h
//  TokenBank
//
//  Created by MarcusWoo on 10/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TPOS)

+ (UIViewController *)tb_rootViewController;
+ (instancetype)tb_topPresentedViewController;
+ (instancetype)tb_topPresentedViewControllerIgnoringNavi;

@end
