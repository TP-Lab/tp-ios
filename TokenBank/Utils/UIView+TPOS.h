//
//  UIView+TPOS.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TPOS)

@property (nonatomic, assign) CGFloat tb_width;
@property (nonatomic, assign) CGFloat tb_height;
@property (nonatomic, assign) CGFloat tb_centerX;
@property (nonatomic, assign) CGFloat tb_centerY;
@property (nonatomic, assign) CGFloat tb_x;
@property (nonatomic, assign) CGFloat tb_y;

- (void)tb_offset:(CGPoint)point;

- (void)tb_setPosition:(CGPoint)position;

- (void)tb_setSize:(CGSize)size;

- (CGPoint)tb_postion;

- (CGSize)tb_size;

- (CGPoint)tb_boundsCenter;

- (CGFloat)tb_left;

- (CGFloat)tb_top;

- (CGFloat)tb_right;

- (CGFloat)tb_bottom;

- (void)tb_setLeft:(CGFloat)lef;

- (void)tb_setRight:(CGFloat)right;

- (void)tb_setTop:(CGFloat)top;

- (void)tb_setBottom:(CGFloat)bottom;

- (UIImage *)tb_snapshot;

@end
