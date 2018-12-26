//
//  TPOSCreateWalletViewController.h
//  TPOSUIProject
//
//  Created by yf on 06/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSBlockChainModel;

@interface TPOSCreateWalletViewController : TPOSBaseViewController

@property (nonatomic, strong) TPOSBlockChainModel *blockChainModel;

@property (nonatomic, assign) BOOL ignoreBackup;

@end
