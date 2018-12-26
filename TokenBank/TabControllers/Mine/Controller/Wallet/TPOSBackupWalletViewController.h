//
//  BackupWalletViewController.h
//  TPOSUIProject
//
//  Created by yf on 06/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSWalletModel;

@interface TPOSBackupWalletViewController : TPOSBaseViewController

@property (nonatomic, strong) TPOSWalletModel *walletModel;
@property (nonatomic, copy) NSString *mnemonic;

@end
