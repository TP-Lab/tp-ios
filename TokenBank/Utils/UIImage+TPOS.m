//
//  UIImage+TPOS.m
//  TokenBank
//
//  Created by MarcusWoo on 04/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "UIImage+TPOS.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (TPOS)

+ (UIImage *)tb_imageWithURL:(NSURL *)url {
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:NULL];
    
    if ([response statusCode] == 200) {
        return [UIImage imageWithData:data];
    }
    
    return nil;
}

+ (UIImage *)tb_imageNamed:(NSString *)name scale:(float)scale {
    UIImage *image = [UIImage imageNamed:name];
    
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
}

+ (UIImage *)tb_imageNamed:(NSString *)name rect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:name];
    CGImageRef c_image = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *img = [[UIImage alloc] initWithCGImage:c_image];
    
    CGImageRelease(c_image);
    return img;
}

+ (UIImage *)tb_imageWithContentsOfFile:(NSString *)path rect:(CGRect)rect {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    CGImageRef c_image = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *img = [[UIImage alloc] initWithCGImage:c_image];
    
    CGImageRelease(c_image);
    return img;
}

- (UIImage *)tb_blurredImage:(CGFloat)blurAmount {
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    }
    
    if (error) {
        CFRelease(inBitmapData);
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)tb_imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)tb_imageWithImage:(UIImage *)image alpha:(CGFloat)alpha {
    UIImage *img = nil;
    CGSize size = image.size;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)
            blendMode:kCGBlendModeNormal
                alpha:alpha];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)tb_drawInRect:(CGRect)rect color:(UIColor *)color {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -rect.size.height);
    
    CGColorSpaceRef cRef = CGColorSpaceCreateDeviceGray();
    
    CGContextDrawImage(ctx, rect, self.CGImage);
    CGContextClipToMask(ctx, rect, self.CGImage);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(cRef);
}

- (UIImage *)tb_imageWithTintColor:(UIColor *)tintColor {
    return [self tb_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)tb_imageWithGradientTintColor:(UIColor *)tintColor {
    return [self tb_imageWithTintColor:tintColor blendMode:kCGBlendModeColorDodge];
}

- (UIImage *)tb_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)tb_transformToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
