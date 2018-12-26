//
//  TPOSAssetItem.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAssetItem.h"

@import Masonry;

@interface TPOSAssetItem()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation TPOSAssetItem

+ (TPOSAssetItem *)assetItemWithIcon:(NSString *)icon title:(NSString *)title index:(NSInteger)index {
    TPOSAssetItem *assetItem = [[TPOSAssetItem alloc] initWithFrame:CGRectMake(index*(66+18), 0, 66, 30)];
    assetItem.titleLabel.text = title;
    assetItem.iconImageView.image = [UIImage imageNamed:icon];
    return assetItem;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *iv = [UIImageView new];
        _iconImageView = iv;
    }
    return _iconImageView;
}

@end
