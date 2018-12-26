//
//  TPOSCustomMJRefreshFooter.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/8.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSCustomMJRefreshFooter.h"
#import "UIColor+Hex.h"
#import "TPOSLocalizedHelper.h"

@import Masonry;

@interface TPOSCustomMJRefreshFooter()

@property (nonatomic, assign) BOOL isShowAutoBack;
@property (nonatomic, assign) CGFloat lastContentSize;
@property (nonatomic, strong) UILabel *noMoreDatalabel;
@property (nonatomic, strong) UILabel *idelLabel;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshLoadingImage;
@property (nonatomic, strong) UIView *centerView;

@end


@implementation TPOSCustomMJRefreshFooter


- (void)setNoMoreDataAutoBack {
    _isShowAutoBack = YES;
}

- (void)prepare {
    [super prepare];
    self.mj_h = 44;
    [self addSubview:self.noMoreDatalabel];
    [self addSubview:self.centerView];
    [self addSubview:self.idelLabel];
    [self addSubview:self.refreshLabel];
    [self addSubview:self.refreshLoadingImage];
}

- (void)placeSubviews {
    [super placeSubviews];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.idelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.noMoreDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.refreshLoadingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView);
        make.centerY.equalTo(self.centerView);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.refreshLoadingImage.mas_right).offset(6);
        make.right.equalTo(self.centerView);
        make.centerY.equalTo(self.refreshLoadingImage);
    }];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    if (self.state != MJRefreshStateNoMoreData) {
        return;
    }
    if (self.scrollView.contentSize.height == _lastContentSize) {
        return;
    }
    
    if (self.scrollView.contentSize.height >= self.scrollView.frame.size.height) {
        self.noMoreDatalabel.hidden = NO;
    } else {
        self.noMoreDatalabel.hidden = YES;
    }
    _lastContentSize = self.scrollView.contentSize.height;
}


- (void)setState:(MJRefreshState)state {
    [super setState:state];
    switch (state) {
        case MJRefreshStateIdle:
            if (_isShowAutoBack && self.scrollView != nil && self.scrollView.mj_insetB != 0) {
                self.scrollView.mj_insetB = 0;
            }
            self.noMoreDatalabel.hidden = YES;
            self.idelLabel.hidden = NO;
            self.refreshLabel.hidden = YES;
            self.refreshLoadingImage.hidden = YES;
            [self.refreshLoadingImage.layer removeAllAnimations];
            break;
        case MJRefreshStateRefreshing:
        {
            if (_isShowAutoBack && self.scrollView != nil && self.scrollView.mj_insetB != 0) {
                self.scrollView.mj_insetB = 0;
            }
            self.noMoreDatalabel.hidden = YES;
            self.idelLabel.hidden = YES;
            self.refreshLabel.hidden = NO;
            self.refreshLoadingImage.hidden = NO;
            // 1.创建动画
            CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            
            // 2.设置动画的属性
            rotationAnim.fromValue = @0;
            rotationAnim.toValue = @(M_PI * 2);
            rotationAnim.repeatCount = MAXFLOAT;
            rotationAnim.duration = 0.5;
            // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
            rotationAnim.removedOnCompletion = NO;
            // 3.将动画添加到layer中
            [self.refreshLoadingImage.layer addAnimation:rotationAnim forKey:@"rotationAnimation"];
        }
            break;
        case MJRefreshStateNoMoreData:
            if (_isShowAutoBack && self.scrollView != nil && self.scrollView.mj_insetB != 0) {
                self.scrollView.mj_insetB = 0;
            }
            if (self.scrollView.contentSize.height >= self.scrollView.frame.size.height) {
                self.noMoreDatalabel.hidden = NO;
            } else {
                self.noMoreDatalabel.hidden = YES;
            }
            self.idelLabel.hidden = YES;
            self.refreshLabel.hidden = YES;
            self.refreshLoadingImage.hidden = YES;
            [self.refreshLoadingImage.layer removeAllAnimations];
            break;
        default:
            break;
    }
}

- (UILabel *)noMoreDatalabel {
    if (!_noMoreDatalabel) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithHex:0x9b9b9b];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"reach_bottom"];
        _noMoreDatalabel = label;
    }
    return _noMoreDatalabel;
}

- (UILabel *)idelLabel {
    if (!_idelLabel) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithHex:0x9b9b9b];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"slide_load_more"];
        _idelLabel = label;
    }
    return _idelLabel;
}

- (UILabel *)refreshLabel {
    if (!_refreshLabel) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithHex:0x9b9b9b];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"loading_more"];
        _refreshLabel = label;
    }
    return _refreshLabel;
}

- (UIImageView *)refreshLoadingImage {
    if (!_refreshLoadingImage) {
        UIImageView *ivSeprateLine = [UIImageView new];
        ivSeprateLine.contentMode = UIViewContentModeCenter;
        ivSeprateLine.image = [UIImage imageNamed:@"footer_refresh_loading"];
        _refreshLoadingImage = ivSeprateLine;
    }
    return _refreshLoadingImage;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [UIView new];
    }
    return _centerView;
}

@end

