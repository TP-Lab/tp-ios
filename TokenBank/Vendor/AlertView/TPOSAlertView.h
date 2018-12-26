//
//  TPOSAlertView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPOSAlertViewAnimateType) {
    TPOSAlertViewAnimateBottomUp,
    TPOSAlertViewAnimateCenterPop,
    TPOSAlertViewAnimateGiftCountUp,
};

@interface TPOSAlertView : UIView

@property (nonatomic, strong) UIButton *transparentButton;
@property (nonatomic, assign) BOOL canDismissByTouchBackground;// 默认为 YES
@property (nonatomic, assign) CGFloat bottomOffset; // 默认为 0.0

@property (nonatomic, copy) void (^onHideBlock)(void);
@property (nonatomic, copy) void (^onShowBlock)(void);


+ (UIWindow *)getTopWindow;
+ (void)hideAll;
- (void)showWithAnimate:(TPOSAlertViewAnimateType)type inView:(UIView*)inView;
- (void)showWithAnimate:(TPOSAlertViewAnimateType)type;
- (void)show;
- (void)showInview:(UIView*)uiView;
- (void)hide;

@end
