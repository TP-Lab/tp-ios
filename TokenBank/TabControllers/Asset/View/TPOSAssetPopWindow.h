//
//  TPOSAssetPopWindow.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOSAssetPopWindow : UIControl

+ (void)showInView:(UIView *)view callBack:(void (^)(NSInteger index))callBack;

@end
