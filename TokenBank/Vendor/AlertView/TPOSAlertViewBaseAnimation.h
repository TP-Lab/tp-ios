//
//  TPOSAlertViewBaseAnimation.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPOSAletViewAnimationProtocol <NSObject>
@required
- (void)show;
- (void)showInView:(UIView *)uiView;
- (void)hide;
@end

@class TPOSAlertView;

@interface TPOSAlertViewBaseAnimation : NSObject

@property (nonatomic, weak) TPOSAlertView *alertView;
- (instancetype)initWithAlertView:(TPOSAlertView *)view;
@end

// 从下向上的动画效果
@interface TPOSAlertViewBottomUpAnimation : TPOSAlertViewBaseAnimation<TPOSAletViewAnimationProtocol>
@end

// 从屏幕中间弹出动画效果
@interface TPOSAlertViewCenterPopAnimation : TPOSAlertViewBaseAnimation<TPOSAletViewAnimationProtocol>
@end
