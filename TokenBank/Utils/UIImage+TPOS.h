//
//  UIImage+TPOS.h
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPOS)

+ (UIImage *)tb_imageWithURL:(NSURL *)url;

+ (UIImage *)tb_imageNamed:(NSString *)name scale:(float)scale;

+ (UIImage *)tb_imageNamed:(NSString *)name rect:(CGRect)rect;

+ (UIImage *)tb_imageWithContentsOfFile:(NSString *)path rect:(CGRect)rect;

- (UIImage *)tb_blurredImage:(CGFloat)blurAmount;

+ (UIImage *)tb_imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)tb_imageWithImage:(UIImage *)image alpha:(CGFloat)alpha;

- (UIImage *)tb_imageWithTintColor:(UIColor *)tintColor;

- (UIImage *)tb_transformToSize:(CGSize)newSize;

@end
