//
//  TPOSAlertViewBaseAnimation.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertViewBaseAnimation.h"
#import "TPOSAlertView.h"
#import "UIView+TPOS.h"

@implementation TPOSAlertViewBaseAnimation

- (instancetype)init
{
    NSAssert(0, @"use initWithAlertView methods");
    return nil;
}
- (instancetype)initWithAlertView:(TPOSAlertView *)view
{
    self = [super init];
    if (self) {
        self.alertView = view;
    }
    return self;
}
- (void)show
{
    NSAssert(0, @"implement by subClass!");
}

- (void)hide
{
    NSAssert(0, @"implement by subClass!");
}

- (void)showInView:(UIView *)uiView {
    NSAssert(0, @"implement by subClass!");
    
}


@end

@implementation TPOSAlertViewBottomUpAnimation
- (void)show
{
    UIWindow *key = [TPOSAlertView getTopWindow];
    
    [self configViewWithSuper:key];
    [self.alertView tb_setBottom:key.tb_height];
    self.alertView.transform = CGAffineTransformMakeTranslation(0, self.alertView.frame.size.height);
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alertView.transform = CGAffineTransformIdentity;
                         self.alertView.transparentButton.alpha = 1;
                         self.alertView.alpha = 1;
                         [self.alertView tb_setBottom:key.tb_bottom];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [key makeKeyAndVisible];
}

- (void)showInView:(UIView *)uiView
{
    UIView *key = uiView;//[TPOSAlertView getTopWindow];
    
    [self configViewWithSuper:key];
    
    [self.alertView tb_setBottom:key.tb_height];
    self.alertView.transform = CGAffineTransformMakeTranslation(0, self.alertView.tb_height);
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alertView.transform = CGAffineTransformIdentity;
                         self.alertView.transparentButton.alpha = 1;
                         self.alertView.alpha = 1;
                         [self.alertView tb_setBottom:key.tb_height  - self.alertView.bottomOffset];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.alpha = 0;
        self.alertView.transparentButton.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeTranslation(0, self.alertView.tb_height);
    } completion:^(BOOL finished) {
        [self.alertView.transparentButton removeFromSuperview];
        [self.alertView removeFromSuperview];
    }];
}

- (void)configViewWithSuper:(UIView *)key{
    self.alertView.transform = CGAffineTransformIdentity;
    self.alertView.alpha = 0.0;
    self.alertView.transparentButton.alpha = 0;
    
    [key addSubview:self.alertView.transparentButton];
    [self.alertView.transparentButton setFrame:key.bounds];
    self.alertView.alpha = 1.0;
    [self.alertView.transparentButton addSubview:self.alertView];
    
}
@end

@implementation TPOSAlertViewCenterPopAnimation
- (void)show
{
    UIWindow *key = [TPOSAlertView getTopWindow];
    [self showConfig:key];
    //    [key addSubview:self.alertView.transparentButton];
    //    [key addSubview:self.alertView];
    //    [self.alertView.transparentButton setFrame:key.bounds];
    //
    //    CGSize keySize = key.frame.size;
    //    self.alertView.transparentButton.alpha = 0;
    //    self.alertView.center = CGPointMake(keySize.width / 2, keySize.height / 2);
    //    self.alertView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    //    self.alertView.alpha = 0.0f;
    //    self.alertView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    //
    //    [UIView animateWithDuration:0.35
    //                          delay:0
    //         usingSpringWithDamping:0.8
    //          initialSpringVelocity:1
    //                        options:UIViewAnimationOptionCurveEaseInOut
    //                     animations:^{
    //                         self.alertView.transform = CGAffineTransformIdentity;
    //                         self.alertView.transparentButton.alpha = 1;
    //                         self.alertView.alpha = 1;
    //                     }
    //                     completion:^(BOOL finished) {
    //
    //                     }];
    
}

- (void)showInView:(UIView *)uiView {
    [self showConfig:uiView];
}

- (void)showConfig:(UIView *)view {
    //    UIWindow *key = [TPOSAlertView getTopWindow];
    [view addSubview:self.alertView.transparentButton];
    [view addSubview:self.alertView];
    [self.alertView.transparentButton setFrame:view.bounds];
    
    CGSize keySize = view.frame.size;
    self.alertView.transparentButton.alpha = 0;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        self.alertView.center = CGPointMake(keySize.width / 2, keySize.height / 2 );
    } else {
        self.alertView.center = CGPointMake(keySize.width / 2, keySize.height / 2 - 50);
    }
    self.alertView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.alertView.alpha = 0.0f;
    self.alertView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alertView.transform = CGAffineTransformIdentity;
                         self.alertView.transparentButton.alpha = 1;
                         self.alertView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.alpha = 0;
        self.alertView.transparentButton.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self.alertView.transparentButton removeFromSuperview];
        [self.alertView removeFromSuperview];
    }];
}

@end
