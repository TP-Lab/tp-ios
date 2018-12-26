//
//  TPOSChooseTokenCell.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSTokenModel;

@interface TPOSChooseTokenCell : UITableViewCell

- (void)updateWithModel:(TPOSTokenModel *)tokenModel;

@end
