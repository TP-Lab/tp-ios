//
//  TPOSConfirmPrivateKeyViewController.h
//  TPOSUIProject
//
//  Created by yf on 07/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSWalletModel;

@interface TPOSConfirmMemonicViewController : TPOSBaseViewController

@property (nonatomic, strong) TPOSWalletModel *walletModel;
@property (nonatomic, strong) NSArray *memonicWords;

@end
