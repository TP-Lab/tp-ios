//
//  TPOSShareView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/1.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSShareView.h"
#import "UIView+TPOS.h"

@interface TPOSShareView()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation TPOSShareView

+ (UIImage *)shareImageByQrcodeImage:(UIImage *)qrCodeImage address:(NSString *)address {
    TPOSShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"TPOSShareView" owner:nil options:nil] firstObject];
    shareView.qrCodeImageView.image = qrCodeImage;
    shareView.addressLabel.text = address;
    return [shareView tb_snapshot];
}

+ (CGFloat)qrCodeImageWidth {
    return 155;
}

@end
