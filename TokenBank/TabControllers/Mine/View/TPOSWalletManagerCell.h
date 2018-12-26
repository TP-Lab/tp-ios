//
//  TPOSWalletManagerCell.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/8.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOSWalletModel;

@interface TPOSWalletManagerCell : UITableViewCell

- (void)updateWithModel:(TPOSWalletModel *)walletModel;

@end
