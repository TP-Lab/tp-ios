//
//  TPOSMemonicImportWalletViewController.h
//  TokenBank
//
//  Created by MarcusWoo on 10/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSBaseViewController.h"

@class TPOSBlockChainModel;

@interface TPOSMemonicImportWalletViewController : TPOSBaseViewController
@property (nonatomic, strong) TPOSBlockChainModel *blockchain;
@property (nonatomic, strong) NSString *scanResult;
@end
