//
//  TPOSGuideCCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSGuideCCell.h"
#import <SDWebImage/UIImage+GIF.h>
#import "TPOSMacro.h"
#import "YCFrameAnimator.h"

@implementation TPOSGuideModel
@end

@interface TPOSGuideCCell()

@property (weak, nonatomic) IBOutlet UILabel *guideTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *guideSubTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guideImageViewHeight;

@property (nonatomic, strong) UIImage *gifImage;

@property (nonatomic, strong) TPOSGuideModel *guideModel;

@property (nonatomic, assign) BOOL stop;

@end

@implementation TPOSGuideCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _guideImageViewHeight.constant = kScreenWidth * 320 / 375;
}

#pragma mark - public method
- (void)updateWithGuideModel:(TPOSGuideModel *)guideModel {
    _guideModel = guideModel;
    _guideTitleLabel.text = guideModel.title;
    _guideSubTitleLable.text = guideModel.subTitle;
    
    _gifImage = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:guideModel.giftImageName ofType:nil]]];
    self.guideImageView.image = [UIImage imageNamed:guideModel.normalImageName];
}

- (void)startPlayGif {
    _stop = NO;
    MilliTime keyDuration = _gifImage.duration * 1000 / _gifImage.images.count;
    
    __weak typeof(self) weakSelf = self;
    [self.guideImageView makeKeyFrameWithImages:_gifImage.images repeats:NO time:^MilliTime(int index, UIImage * _Nonnull image) {
        return keyDuration;
    } complement:^BOOL(int index) {
        return !weakSelf.stop;
    }];
}

- (void)stopPlayGif {
    _stop = YES;
    self.guideImageView.image = [UIImage imageNamed:_guideModel.normalImageName];
}

#pragma mark - private method

@end
