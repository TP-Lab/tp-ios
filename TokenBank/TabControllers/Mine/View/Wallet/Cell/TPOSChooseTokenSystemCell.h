//
//  TPOSChooseTokenSystemCell.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSBlockChainModel;

@interface TPOSChooseTokenSystemCell : UITableViewCell

- (void)updateWithModel:(TPOSBlockChainModel *)blockChainModel;

- (BOOL)canCreateAble;

@end
