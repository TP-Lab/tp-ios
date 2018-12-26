//
//  TPOSBackupAlert.h
//  TokenBank
//
//  Created by xiaoyuan on 2018/3/4.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAlertView.h"

@class TPOSWalletModel;

@interface TPOSBackupAlert : TPOSAlertView

+ (TPOSBackupAlert *)showWithWalletModel:(TPOSWalletModel *)walletModel inView:(UIView *)view navigation:(UINavigationController *)navi;

@end
