//
//  TPOSTabBarController.h
//  TokenBank
//
//  Created by MarcusWoo on 03/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOSTabBarController : UITabBarController

+ (instancetype)currentInstance;

- (void)setTabBarHidden:(BOOL)tabBarHidden;
@end
