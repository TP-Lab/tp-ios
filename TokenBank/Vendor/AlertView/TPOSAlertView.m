//
//  TPOSAlertView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"
#import "TPOSAlertViewBaseAnimation.h"

#define KP_kHideAllAlert @"hideAllAlertAnimationNotification"

@interface TPOSAlertView ()
@property (nonatomic, strong) id<TPOSAletViewAnimationProtocol>animation;
@end

@implementation TPOSAlertView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.canDismissByTouchBackground = YES;
        self.bottomOffset = 0.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenClick:) name:KP_kHideAllAlert object:nil];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.canDismissByTouchBackground = YES;
        self.bottomOffset = 0.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenClick:) name:KP_kHideAllAlert object:nil];
    }
    return self;
}

+ (UIWindow *)getTopWindow
{
    UIWindow *key = [[UIApplication sharedApplication] keyWindow];
    return key;
}

+ (void)hideAll {
    [[NSNotificationCenter defaultCenter] postNotificationName:KP_kHideAllAlert object:nil];
}

- (void)_show
{
    [self.animation show];
    if (self.onShowBlock) {
        self.onShowBlock();
    }
}

- (void)hiddenClick:(id)sender
{
    if (self.canDismissByTouchBackground) {
        [self cancelView];
        [self hide];
    }
}

- (void)show {
    [self showWithAnimate:TPOSAlertViewAnimateBottomUp];
}

- (void)showWithAnimate:(TPOSAlertViewAnimateType)type
{
    self.animation = [self animationWithType:type];
    [self performSelectorOnMainThread:@selector(_show) withObject:nil waitUntilDone:YES];
}

- (void)hide {
    if (self.animation && self.superview) {
        [self.animation hide];
        if (self.onHideBlock) {
            self.onHideBlock();
        }
    }
}

- (void)cancelView
{
    
}

- (UIButton *)transparentButton {
    if (!_transparentButton) {
        _transparentButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _transparentButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        //        _transparentButton.backgroundColor = [UIColor clearColor];
        [_transparentButton addTarget:self action:@selector(hiddenClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(catchPan)];
        [_transparentButton addGestureRecognizer:pan];
    }
    return _transparentButton;
}

// 增加新的动画类型需要修改这里返回对应类型的动画对象
- (id<TPOSAletViewAnimationProtocol>)animationWithType:(TPOSAlertViewAnimateType)type
{
    switch (type) {
        case TPOSAlertViewAnimateBottomUp:
            return [[TPOSAlertViewBottomUpAnimation alloc] initWithAlertView:self];
            
        case TPOSAlertViewAnimateCenterPop:
            return [[TPOSAlertViewCenterPopAnimation alloc] initWithAlertView:self];
        default:
            return nil;
    }
}


//有View的
- (void)showInview:(UIView*)uiView {
    [self showWithAnimate:TPOSAlertViewAnimateBottomUp inView:uiView];
}

- (void)showWithAnimate:(TPOSAlertViewAnimateType)type inView:(UIView*)inView
{
    self.animation = [self animationWithType:type];
    [self performSelectorOnMainThread:@selector(_showInView:) withObject:inView waitUntilDone:YES];
}

- (void)_showInView:(UIView*)inView
{
    if (self.onShowBlock) {
        self.onShowBlock();
    }
    [self.animation showInView:inView];
}

- (void)catchPan {
    // do nothing
    //    [self hide];
}

@end
