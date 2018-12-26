//
//  TPOSShareCCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/28.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSShareCCell.h"

@interface TPOSShareCCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation TPOSShareCCell

- (void)updateWithTitle:(NSString *)title image:(UIImage *)image {
    _iconImageView.image = image;
    _titleLabel.text = title;
}

@end
