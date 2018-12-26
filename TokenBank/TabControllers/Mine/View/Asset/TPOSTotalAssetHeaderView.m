//
//  TPOSTotalAssetHeaderView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTotalAssetHeaderView.h"
#import "UIColor+Hex.h"
#import "TPOSLocalizedHelper.h"

@import Masonry;

@interface TPOSTotalAssetHeaderView()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *assetLabel;

@property (nonatomic, copy) NSString *unit;

@end

@implementation TPOSTotalAssetHeaderView

- (void)updateAsset:(NSString *)asset unit:(NSString *)unit {
    self.unit = unit;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"total_asset_title"],unit];
    self.assetLabel.text = asset;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)changeLanguage {
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"total_asset_title"],_unit];
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithHex:0x2890FE];
    [self addSubview:self.titleLabel];
    [self addSubview:self.assetLabel];
    
    [self addConstraints];
}

- (void)addConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.centerX.equalTo(self);
    }];
    [self.assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.5);
        make.centerX.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)assetLabel {
    if (!_assetLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:34];
        titleLabel.textColor = [UIColor whiteColor];
        _assetLabel = titleLabel;
    }
    return _assetLabel;
}

@end
