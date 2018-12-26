//
//  TPOSShareView.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/1.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOSShareView : UIView

+ (UIImage *)shareImageByQrcodeImage:(UIImage *)qrCodeImage address:(NSString *)address;

+ (CGFloat)qrCodeImageWidth;

@end
