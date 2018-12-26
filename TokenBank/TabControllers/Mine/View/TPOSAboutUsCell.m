//
//  TPOSAboutUsCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/7.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAboutUsCell.h"
#import "UIDevice+Utility.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSAboutUsCell()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation TPOSAboutUsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _versionLabel.text = [NSString stringWithFormat:@"%@：%@",[[TPOSLocalizedHelper standardHelper] stringWithKey:@"curr_version"],[[UIDevice currentDevice] tb_appVersion]];
}

- (void)changeLanguage {
    self.descLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"about_us_desc"];
}

@end
