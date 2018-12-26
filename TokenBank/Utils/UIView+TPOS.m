//
//  UIView+TPOS.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/10.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "UIView+TPOS.h"

@implementation UIView (TPOS)

- (CGFloat)tb_width {
    return self.frame.size.width;
}

- (CGFloat)tb_height {
    return self.frame.size.height;
}

- (void)setTb_width:(CGFloat)tb_width {
    CGRect frame = self.frame;
    
    frame.size.width = tb_width;
    self.frame = frame;
}

- (void)setTb_height:(CGFloat)tb_height {
    CGRect frame = self.frame;
    
    frame.size.height = tb_height;
    self.frame = frame;
}

- (CGFloat)tb_centerX {
    return self.center.x;
}

- (CGFloat)tb_centerY {
    return self.center.y;
}

- (void)setTb_centerX:(CGFloat)tb_centerX {
    CGPoint center = self.center;
    center.x = tb_centerX;
    self.center = center;
}

- (void)setTb_centerY:(CGFloat)tb_centerY {
    CGPoint center = self.center;
    center.y = tb_centerY;
    self.center = center;
}

- (CGFloat)tb_x {
    return self.frame.origin.x;
}

- (CGFloat)tb_y {
    return self.frame.origin.y;
}

- (void)setTb_x:(CGFloat)tb_x {
    CGRect frame = self.frame;
    frame.origin.x = tb_x;
    self.frame = frame;
}

- (void)setTb_y:(CGFloat)tb_y {
    CGRect frame = self.frame;
    frame.origin.y = tb_y;
    self.frame = frame;
}

- (void)tb_offset:(CGPoint)point {
    CGRect frame = self.frame;
    
    frame.origin.x += point.x;
    frame.origin.y += point.y;
    self.frame = frame;
}

- (void)tb_setPosition:(CGPoint)position {
    CGRect frame = self.frame;
    
    frame.origin.x = position.x;
    frame.origin.y = position.y;
    self.frame = frame;
}

- (void)tb_setSize:(CGSize)size {
    CGRect frame = self.frame;
    
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)tb_postion {
    return self.frame.origin;
}

- (CGSize)tb_size {
    return self.frame.size;
}

- (CGPoint)tb_boundsCenter {
    CGSize size = self.bounds.size;
    
    return CGPointMake(size.width / 2, size.height / 2);
}

- (CGFloat)tb_left {
    return self.frame.origin.x;
}

- (CGFloat)tb_top {
    return self.frame.origin.y;
}

- (CGFloat)tb_right {
    return [self tb_left] + [self tb_width];
}

- (CGFloat)tb_bottom {
    return [self tb_top] + [self tb_height];
}

- (void)tb_setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    
    frame.origin.x = left;
    self.frame = frame;
}

- (void)tb_setRight:(CGFloat)right {
    CGRect frame = self.frame;
    
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)tb_setTop:(CGFloat)top {
    CGRect frame = self.frame;
    
    frame.origin.y = top;
    self.frame = frame;
}

- (void)tb_setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (UIImage *)tb_snapshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
